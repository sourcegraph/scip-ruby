def basename(p):
    return p.rpartition("/")[-1]

def extension(p):
    ext = basename(p).partition(".")[-1]
    if ext == ",": # partition returns "," if there is no match 🙃
        return ""
    return ext

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

    ext = extension(path)
    if ext == "snapshot":
        return 
    
    if ext != "rb":
        # TODO(varun): Add support for folder tests, when there is no extension
        return None

    test_name = basename(path).partition(".")[0]
    snapshot_path = path + ".snapshot"
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