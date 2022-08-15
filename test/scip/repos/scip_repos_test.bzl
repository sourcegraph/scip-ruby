load("//third_party:test_gem_data.bzl", "gem_build_info")

# For more context, see NOTE[repo-test-structure]

def _scip_repo_test_cache_rule(ctx):
    target_zip_list = ctx.attr.target.files.to_list()
    inputs = target_zip_list + [ctx.file._standalone_ruby_tgz]
    gem_name = ctx.label.name
    toolchain_cache = ctx.actions.declare_file("cache/{}/ruby-post-bundle-cache.tgz".format(gem_name))
    gem_with_vendor_cache = ctx.actions.declare_file("cache/{}/gem-post-vendor.tgz".format(gem_name))
    outputs = [toolchain_cache, gem_with_vendor_cache]
    if len(target_zip_list) != 1:
        fail("Expected exactly 1 zip file in filegroup but found {} for {}".format(
            len(target_zip_list),
            ctx.attr.target,
        ))

    # In CI, the gem build needs to use the same 'gem' as this task, so before
    # we delete/overwrite, let that job finish.
    if ctx.var["SCIP_RUBY_RBENV_EXE"] == "RUNNING_IN_CI_RBENV_NOT_NEEDED":
        inputs += ctx.attrs._scip_ruby_gems.files.to_list()

    ctx.actions.run(
        outputs = outputs,
        inputs = inputs,
        mnemonic = "BundleCache",
        executable = ctx.file._bundle_cache_script,
        env = {
            # Ideally, we would pass in a C compiler here too, but 🤷🏽
            "SCIP_RUBY_CACHE_RUBY_DIR": ctx.var["SCIP_RUBY_CACHE_RUBY_DIR"],
            "RUBY_VERSION_FILE": ctx.file._ruby_version.path,
            "PRISTINE_TOOLCHAIN_TGZ_PATH": ctx.file._standalone_ruby_tgz.path,
            "TEST_GEM_ZIP": target_zip_list[0].path,
            "TEST_GEM_ZIP_PREFIX": ctx.attr.strip_prefix,
            "TEST_GEM_SUBDIR": ctx.attr.subdir,
            "OUT_MODIFIED_TOOLCHAIN_TGZ_PATH": toolchain_cache.path,
            "OUT_GEM_WITH_VENDOR_TGZ_PATH": gem_with_vendor_cache.path,
        },
    )
    return [DefaultInfo(files = depset(outputs), runfiles = ctx.runfiles(files = outputs))]

scip_repo_test_cache_rule = rule(
    implementation = _scip_repo_test_cache_rule,
    attrs = {
        "_standalone_ruby_tgz": attr.label(default = "//gems/scip-ruby:standalone-ruby", allow_single_file = True),
        "_bundle_cache_script": attr.label(default = ":bundle_cache.sh", allow_single_file = True),
        "_ruby_version": attr.label(default = "//:.ruby-version", allow_single_file = True),
        "_scip_ruby_gems": attr.label(default = "//gems/scip-ruby"),
        "target": attr.label(mandatory = True),
        "strip_prefix": attr.string(mandatory = True),
        "subdir": attr.string(mandatory = True),
    },
    doc = "Intermediate cache archives for gems after running 'bundle cache'.",
)

def register_scip_repo_test_caches():
    for gem_data in gem_build_info:
        gem_name = gem_data["repo_name"]
        scip_repo_test_cache_rule(
            name = "prep_{}".format(gem_name),
            target = "@{}_zip//file".format(gem_name),
            strip_prefix = gem_data["strip_prefix"],
            subdir = gem_data["gem_subdir"],
        )

def scip_repos_test_suite(name, patch_paths):
    available_patches = {p: None for p in patch_paths}
    test_names = []
    consumed = {}
    for gem_data in gem_build_info:
        gem_name = gem_data["repo_name"]
        patch_basename = "{}-{}".format(gem_name, gem_data["ref"])
        extra_deps = {}
        gem_dep = {}
        patch_arg = {}
        for os in ["//tools/config:linux", "//tools/config:darwin"]:
            candidates = [patch_basename + ".patch"]
            if "linux" in os:
                candidates.append(patch_basename + "-linux.patch")
                gem_dep[os] = "//gems/scip-ruby/scip-ruby-debug-0.0.0-x86_64-linux.gem"
            else:
                candidates.append(patch_basename + "-darwin.patch")

                # NOTE: Keep in sync with index_gem.sh.
                gem_dep[os] = "//gems/scip-ruby/scip-ruby-debug-0.0.0-universal-darwin-20.gem"
            extra_deps[os] = []
            for patch_path in candidates:
                if patch_path in available_patches:
                    extra_deps[os].append(patch_path)
                    patch_arg[os] = "$(location {})".format(patch_path)
                    consumed[patch_path] = None
                    if "linux" in patch_path or "darwin" in patch_path:
                        available_patches.pop(patch_path, None)

        prep_target = ":prep_{}".format(gem_name)
        data = [prep_target, "//gems/scip-ruby", "//:.ruby-version"]

        test_name = gem_name
        native.sh_test(
            name = test_name,
            size = "medium",  # Should finish in 5 minutes
            srcs = ["index_gem.sh"],
            data = data + select(extra_deps),
            # Tests run serially since they share the same cache dir.
            # For more context, see NOTE[repo-test-structure].
            tags = ["exclusive"],
            env = select(
                {os: {
                    "SCIP_RUBY_CACHE_RUBY_DIR": "$(SCIP_RUBY_CACHE_RUBY_DIR)",
                    "RUBY_VERSION_FILE": "$(location //:.ruby-version)",
                    "SCIP_RUBY_GEMS": "$(locations //gems/scip-ruby)",
                    "CACHED_TGZS": "$(locations {})".format(prep_target),
                    "REPO_NAME": gem_data["repo_name"],
                    "PATCH_PATH": pa,
                } for os, pa in patch_arg.items()},
            ),
        )
        test_names.append(test_name)

    for p in consumed:
        available_patches.pop(p, None)

    # if len(available_patches) != 0:
    #     fail("Patches {} were not used by any tests".format(available_patches))
    # FIXME(varun): Get the brew test working and turn this on.

    native.test_suite(
        name = name,
        tests = test_names,
    )
