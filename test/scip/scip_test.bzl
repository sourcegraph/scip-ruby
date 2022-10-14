def basename(p):
    return p.rpartition("/")[-1]

def dirname(p):
    return p.rpartition("/")[0]

def split_extension(p):
    (before, _, ext) = p.rpartition(".")
    if before == "":
        (before, ext) = (ext, "")
    return (before, ext)

def scip_test_suite(paths, multifile_paths):
    tests = []
    updates = []
    for path in paths:
        names = scip_test(path)
        if names:
            tests.append(names[0])
            updates.append(names[1])

    file_groups = {}
    for p in multifile_paths:
        d = dirname(p)
        if d in file_groups:
            file_groups[d].append(p)
        else:
            file_groups[d] = [p]

    tests.append(scip_unit_tests())
    for dir, files in file_groups.items():
        names = scip_multifile_test(dir, files)
        tests.append(names[0])
        updates.append(names[1])

    native.test_suite(
        name = "scip",
        tests = tests,
    )
    native.test_suite(
        name = "update",
        tests = updates,
    )

def scip_unit_tests():
    test_name = "unit_tests"
    args = ["unit_tests"]
    native.sh_test(
        name = "unit_tests",
        srcs = ["scip_test_runner.sh"],
        args = ["only_unit_tests"],
        data = ["//test:scip_test_runner"],
        size = "small",
    )
    return "unit_tests"

def scip_test(path):
    if not path.endswith(".rb") or path.endswith(".snapshot.rb"):
        return None
    test_name = basename(path)[:-3]
    snapshot_path = path[:-3] + ".snapshot.rb"
    args = ["$(location {})".format(path), "--output=$(location {})".format(snapshot_path)]
    data = [path, snapshot_path, "//test:scip_test_runner"]
    return _make_test(test_name, args, data)

def scip_multifile_test(dir, filepaths):
    args = ["$(location {})".format(dir), "--output=$(location {})".format(dir)]
    data = ["//test:scip_test_runner", "//test/scip:{}".format(dir)]
    for filepath in filepaths:
        path_without_ext, ext = split_extension(filepath)
        if (ext == "rb" or ext == "rbi") and not path_without_ext.endswith(".snapshot"):
            data.append(filepath)
            if not filepath.endswith("scip-ruby-args.rb"):  # Special file for reading Gem-level args.
                data.append(path_without_ext + ".snapshot." + ext)
    if not dir.startswith("testdata/multifile/"):
        fail("Expected directory to be under multifile/")
    dir = dir[len("testdata/multifile/"):]
    if "/" in dir:
        fail("Expected directory to be 1-level deep under multifile/")

    test_name = "multifile_" + dir
    return _make_test(test_name, args, data)

def _make_test(test_name, args, data):
    native.sh_test(
        name = test_name,
        srcs = ["scip_test_runner.sh"],
        args = args,
        data = data,
        size = "small",
    )
    update_test_name = "update_{}".format(test_name)
    native.sh_test(
        name = update_test_name,
        srcs = ["scip_test_runner.sh"],
        args = args + ["--update-snapshots"],
        data = data,
        tags = ["manual"],
        size = "small",
    )
    return (test_name, update_test_name)
