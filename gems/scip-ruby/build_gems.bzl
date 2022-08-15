def _setup_standalone_ruby(ctx):
    ruby_archive = ctx.actions.declare_file("cache/ruby.tgz")
    inputs = [ctx.file._ruby_version]
    outputs = [ruby_archive]
    ctx.actions.run(
        outputs = outputs,
        inputs = inputs,
        mnemonic = "StandaloneRuby",
        executable = ctx.file._install_script,
        env = {
            # Ideally, we would also pass in a C compiler here, but 🤷🏽
            "SCIP_RUBY_RBENV_EXE": ctx.var["SCIP_RUBY_RBENV_EXE"],
            "SCIP_RUBY_CACHE_RUBY_DIR": ctx.var["SCIP_RUBY_CACHE_RUBY_DIR"],
            "RUBY_VERSION_FILE": ctx.file._ruby_version.path,
            "OUT_TGZ_PATH": ruby_archive.path,
        },
    )
    runfiles = ctx.runfiles(files = outputs)
    return [DefaultInfo(files = depset(outputs), runfiles = runfiles)]

setup_standalone_ruby = rule(
    implementation = _setup_standalone_ruby,
    attrs = {
        "_ruby_version": attr.label(default = "//:.ruby-version", allow_single_file = True),
        "_install_script": attr.label(default = "install_standalone_ruby.sh", allow_single_file = True),
    },
    doc = """
        Creates a standalone ruby installation using rbenv that is only for test use,
        without interfering with any system Ruby. We are not using bazelruby/rules_ruby here
        because it seems largely oriented towards *building* Ruby code, whereas what we
        want to do is install dependencies in a way that mimics common usage (through Bundler).
        """,
)

VersionProvider = provider(fields = ["version"])

def _version(ctx):
    return VersionProvider(version = ctx.build_setting_value)

version = rule(
    implementation = _version,
    # Allow passing in version from outside for CI
    build_setting = config.string(flag = True),
)

def _build_gems(ctx):
    version = ctx.attr._version[VersionProvider].version
    name = ctx.attr.gem_name
    os = ctx.attr.gem_target_os
    darwin_versions = [20, 21, 22]
    if os == "darwin":
        outs = [
            "{}-{}-universal-darwin-{}.gem".format(name, version, dv)
            for dv in darwin_versions
        ]
    else:
        outs = ["{}-{}-x86_64-linux.gem".format(name, version)]
    output_files = [ctx.actions.declare_file(out) for out in outs]

    inputs = ctx.attr._build_script.files.to_list()
    for src in ctx.attr.srcs:
        inputs += src.files.to_list()
    inputs.append(ctx.file._scip_ruby_binary)

    ctx.actions.run(
        outputs = output_files,
        inputs = inputs,
        mnemonic = "BuildSCIPRubyGems",
        executable = ctx.file._build_script,
        env = {
            "EXTERNAL_GEM_EXE": ctx.var["EXTERNAL_GEM_EXE"],
            "NAME": name,
            "VERSION": version,
            "DARWIN_VERSIONS": " ".join([str(dv) for dv in darwin_versions]),
            "SCIP_RUBY_BINARY": ctx.file._scip_ruby_binary.path,
            "OUT_DIR": output_files[0].dirname,
        },
    )
    runfiles = ctx.runfiles(files = output_files)
    return [DefaultInfo(files = depset(output_files), runfiles = runfiles)]

build_gems = rule(
    implementation = _build_gems,
    attrs = {
        "_version": attr.label(default = ":version"),
        "_build_script": attr.label(default = "build_scip_ruby_gems.sh", allow_single_file = True),
        "srcs": attr.label_list(allow_files = True),
        "_scip_ruby_binary": attr.label(default = "//main:scip-ruby", allow_single_file = True),
        "_ruby_version": attr.label(default = "//:.ruby-version", allow_single_file = True),
        "_standalone_ruby_tgz": attr.label(default = "//gems/scip-ruby:standalone-ruby", allow_single_file = True),
        "gem_name": attr.string(),
        "gem_target_os": attr.string(),
    },
    doc = "Builds gems for scip-ruby using 'gem build'.",
)
