load("@emsdk//emscripten_toolchain:wasm_rules.bzl", "wasm_cc_binary")

wasm_options = [
    "-s",
    "EXPORT_NAME=\"Sorbet\"",
    "-s",
    "MODULARIZE=1",
    "-s",
    "EXPORTED_FUNCTIONS=_typecheck,_lsp",
    "-s",
    # - `addFunction` converts a JavaScript function to a C++ function
    #    pointer. It is used in the Sourcegraph extension
    #    https://sourcegraph.com/extensions/sourcegraph/lang-ruby
    #    to enable Sorbet to push JSON-RPC responses to JavaScript and
    #    avoid polling. This requires 1 reserved function pointer
    #    (see RESERVED_FUNCTION_POINTERS below).
    # - `Pointer_stringify` converts a C++ char* to a JavaScript string.
    # "EXPORTED_RUNTIME_METHODS=[\"ccall\",\"cwrap\",\"addFunction\",\"Pointer_stringify\"]",
    "EXPORTED_RUNTIME_METHODS=ccall,cwrap,addFunction,Pointer_stringify",
    "-s",
    "TOTAL_MEMORY=67108864",
    "-s",
    # This let's us allocate 1 JavaScript function (the callback for
    # JSON-RPC responses) as a function pointer for use in C++
    # (see addFunction above).
    "RESERVED_FUNCTION_POINTERS=1",
    "-s",
    "DISABLE_EXCEPTION_CATCHING=2",
]

cc_binary(
    name = "sorbet-wasm.tar",
    copts = select({
        "//tools/config:wasm": wasm_options,
        "//conditions:default": [],
    }),
    linkopts = select({
        "//tools/config:wasm": wasm_options,
        "//conditions:default": [],
    }),
    linkstatic = select({
        "//tools/config:linkshared": 0,
        "//conditions:default": 1,
    }),
    visibility = ["//visibility:public"],
    deps = [
        ":main",
    ],
)

cc_library(
    name = "main",
    srcs = ["main.cc"],
    linkstatic = select({
        "//tools/config:linkshared": 0,
        "//conditions:default": 1,
    }),
    visibility = ["//visibility:public"],
    deps = [
        "//main:realmain",
        "//main/pipeline/semantic_extension:none",
        "//payload/binary:some",
        "//payload/text:empty",
    ],
    # # TODO(jez) Is there a config_setting we can write to detect when we're
    # # running under wasm_cc_binary?
    # # TODO(jez) Can we detect release mode and turn on closure compiler?
    # linkopts = [
    #     "-s",
    #     "MODULARIZE=1",
    #     "-s",
    #     "EXPORT_NAME=\"Sorbet\"",
    #     "-s",
    #     "EXPORTED_FUNCTIONS=[\"_typecheck\",\"_lsp\"]",
    #     "-s",
    #     # - `addFunction` converts a JavaScript function to a C++ function
    #     #    pointer. It is used in the Sourcegraph extension
    #     #    https://sourcegraph.com/extensions/sourcegraph/lang-ruby
    #     #    to enable Sorbet to push JSON-RPC responses to JavaScript and
    #     #    avoid polling. This requires 1 reserved function pointer
    #     #    (see RESERVED_FUNCTION_POINTERS below).
    #     # - `Pointer_stringify` converts a C++ char* to a JavaScript string.
    #     "EXTRA_EXPORTED_RUNTIME_METHODS=[\"ccall\",\"cwrap\",\"addFunction\",\"Pointer_stringify\"]",
    #     "-s",
    #     "TOTAL_MEMORY=67108864",
    #     "-s",
    #     # This let's us allocate 1 JavaScript function (the callback for
    #     # JSON-RPC responses) as a function pointer for use in C++
    #     # (see addFunction above).
    #     "RESERVED_FUNCTION_POINTERS=1",
    #     "-s",
    #     "DISABLE_EXCEPTION_CATCHING=0",
    # ],
)

cc_binary(
    name = "hello-world.tar",
    srcs = ["hello-world.cc"],
    visibility = ["//visibility:public"],
)

# wasm_cc_binary(
#     name = "sorbet-wasm-new",
#     cc_target = ":main",
# )
