package(default_visibility = ["//visibility:public"])

cc_library(
    name = "liballoc",
    srcs = [
        "liballoc_1_1.cpp",
        "liballoc_1_1.h",
    ],
    defines = ["LIBALLOC_PREFIX(func)=func"],
    includes = ["."],
    deps = ["@musl"],
)
