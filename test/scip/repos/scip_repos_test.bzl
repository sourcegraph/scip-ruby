load("//third_party:test_gem_data.bzl", "gem_build_info")

# For more context, see NOTE[repo-test-structure]

def _assert(cond, msg):
    if not cond:
        fail(msg)

def _scip_repo_test_cache_rule(ctx):
    args = []
    inputs = [ctx.file._standalone_ruby_tgz]
    toolchain_cache = ctx.actions.declare_file("cache/ruby-post-bundle-cache.tgz")
    outputs = [toolchain_cache]
    for target, gem_name in ctx.attr.target.items():
        target_zip_list = target.files.to_list()
        _assert(len(target_zip_list) == 1, "Expected single element in target_zip_list but found: {}".format(target_zip_list))
        target_zip = target_zip_list[0]
        inputs.append(target_zip)
        strip_prefix = ctx.attr.strip_prefix[gem_name]
        subdir = ctx.attr.subdir[gem_name]
        gem_with_vendor_cache = ctx.actions.declare_file("cache/{}/gem-post-vendor.tgz".format(gem_name))
        outputs.append(gem_with_vendor_cache)
        args.append("zip={}:prefix={}:subdir={}:out={}".format(target_zip.path, strip_prefix, subdir, gem_with_vendor_cache.path))

    ctx.actions.run(
        outputs = outputs,
        inputs = inputs,
        mnemonic = "AllBundleCache",
        executable = ctx.file._bundle_cache_script,
        arguments = args,
        env = {
            # Ideally, we would pass in a C compiler here too, but 🤷🏽
            "SCIP_RUBY_CACHE_RUBY_DIR": ctx.var["SCIP_RUBY_CACHE_RUBY_DIR"],
            "RUBY_VERSION_FILE": ctx.file._ruby_version.path,
            "PRISTINE_TOOLCHAIN_TGZ_PATH": ctx.file._standalone_ruby_tgz.path,
            "OUT_MODIFIED_TOOLCHAIN_TGZ_PATH": toolchain_cache.path,
        },
    )
    return [DefaultInfo(files = depset(outputs), runfiles = ctx.runfiles(files = outputs))]

scip_repo_test_cache_rule = rule(
    implementation = _scip_repo_test_cache_rule,
    attrs = {
        "_standalone_ruby_tgz": attr.label(default = "//gems/scip-ruby:standalone-ruby", allow_single_file = True),
        "_bundle_cache_script": attr.label(default = ":bundle_cache.sh", allow_single_file = True),
        "_ruby_version": attr.label(default = "//:.ruby-version", allow_single_file = True),
        "target": attr.label_keyed_string_dict(mandatory = True),
        "strip_prefix": attr.string_dict(mandatory = True),
        "subdir": attr.string_dict(mandatory = True),
    },
    doc = "Intermediate cache archives for gems after running 'bundle cache'.",
)

def register_scip_repo_test_caches():
    scip_repo_test_cache_rule(
        name = "cache_all_deps",
        target = {"@{}_zip//file".format(g["repo_name"]): g["repo_name"] for g in gem_build_info},
        strip_prefix = {g["repo_name"]: g["strip_prefix"] for g in gem_build_info},
        subdir = {g["repo_name"]: g["gem_subdir"] for g in gem_build_info},
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
                gem_dep[os] = "//gems/scip-ruby/scip-ruby-debug-1993.5.16-x86_64-linux.gem"
            else:
                candidates.append(patch_basename + "-darwin.patch")

                # NOTE: Keep in sync with index_gem.sh.
                gem_dep[os] = "//gems/scip-ruby/scip-ruby-debug-1993.5.16-universal-darwin-20.gem"
            extra_deps[os] = []
            for patch_path in candidates:
                if patch_path in available_patches:
                    extra_deps[os].append(patch_path)
                    patch_arg[os] = "$(location {})".format(patch_path)
                    consumed[patch_path] = None
                    if "linux" in patch_path or "darwin" in patch_path:
                        available_patches.pop(patch_path, None)

        prep_target = ":cache_all_deps"
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
