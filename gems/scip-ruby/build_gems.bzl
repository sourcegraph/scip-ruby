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
    for src in (ctx.attr.srcs + [ctx.attr.scip_ruby_target]):
        inputs += src.files.to_list()

    ctx.actions.run(
        outputs = output_files,
        inputs = inputs,
        mnemonic = "BuildGems",
        executable = ctx.attr._build_script.files.to_list()[0],
        env = {
            "NAME": name,
            "DARWIN_VERSIONS": " ".join([str(dv) for dv in darwin_versions]),
            "VERSION": version,
            "SCIP_RUBY_BINARY": ctx.attr.scip_ruby_target.files.to_list()[0].path,
            "OUT_DIR": output_files[0].dirname,
        },
    )
    return [DefaultInfo(files = depset(output_files))]

build_gems = rule(
    implementation = _build_gems,
    attrs = {
        "_version": attr.label(default = ":version"),
        "_build_script": attr.label(default = "build.sh", allow_files = True),
        "srcs": attr.label_list(allow_files = True),
        "scip_ruby_target": attr.label(),
        "gem_name": attr.string(),
        "gem_target_os": attr.string(),
    },
    doc = "Builds gems for scip-ruby using 'gem build'.",
)
