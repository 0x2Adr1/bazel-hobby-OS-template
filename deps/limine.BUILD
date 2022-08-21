package(default_visibility = ["//visibility:public"])

exports_files([
    "limine-cd.bin",
    "limine-cd-efi.bin",
    "limine.sys",
])

cc_library(
    name = "limine",
    hdrs = ["limine.h"],
    include_prefix = "limine",
    includes = ["."],
    deps = ["@musl"],
)

cc_binary(
    name = "limine-deploy",
    srcs = [
        "limine-deploy.c",
        "limine-hdd.h",
    ],
    copts = [
        "-O2",
        "-pipe",
    ],
)
