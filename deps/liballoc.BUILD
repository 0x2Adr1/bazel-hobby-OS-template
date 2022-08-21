package(default_visibility = ["//visibility:public"])

cc_library(
    name = "liballoc",
    srcs = [
        # Our patch file is basically overriding liballoc.h with the content of liballoc_1_1.h
        "liballoc.h",
        "liballoc_1_1.c",
    ],
    defines = ["LIBALLOC_PREFIX(func)=func"],
    includes = ["."],
    deps = ["@musl"],
)
