load("@com_google_protobuf//bazel:cc_proto_library.bzl", "cc_proto_library")
load("@com_google_protobuf//bazel:proto_library.bzl", "proto_library")

proto_library(
    name = "scip_proto",
    srcs = ["SCIP.proto"],
)

cc_proto_library(
    name = "proto",
    visibility = ["//visibility:public"],
    deps = [":scip_proto"],
)
