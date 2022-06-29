def basename(p):
    return p.rpartition("/")[-1]

def split_extension(p):
    (before, _, ext) = basename(p).rpartition(".")
    if before == "":
        (before, ext) = (ext, "")
    return (before, ext)

def scip_test_suite(paths):
    tests = []
    updates = []
    for path in paths:
        names = scip_test(path)
        if names:
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


def scip_test(path):
    # path will end in either .snapshot, .rb or have no extension.

    filename, ext = split_extension(path)
    if ext != "rb":
        # TODO(varun): Add support for folder tests, when there is no extension
        return None
    test_name, other_ext = split_extension(filename)
    if other_ext != "":
        # Don't make separate tests for .snapshot.rb files
        return None

    snapshot_path = path[:-3] + ".snapshot.rb"
    args = ["$(location {})".format(path), "--output=$(location {})".format(snapshot_path)]
    data = [path, snapshot_path, "//test:scip_test_runner"]
    native.sh_test(
        name = test_name,
        srcs = ["scip_test_runner.sh"],
        args = args,
        data = data,
        size = "small",
    )
    update_test_name = "update_".format(test_name) 
    native.sh_test(
        name = update_test_name,
        srcs = ["scip_test_runner.sh"],
        args = args + ["--update-snapshots"],
        data = data,
        tags = ["manual"],
        size = "small",
    )
    return (test_name, update_test_name)