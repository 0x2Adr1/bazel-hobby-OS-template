package(default_visibility = ["//visibility:public"])

genrule(
    name = "gen_alltypes.h",
    srcs = [
        "tools/mkalltypes.sed",
        "arch/x86_64/bits/alltypes.h.in",
        "include/alltypes.h.in",
    ],
    outs = ["alltypes.h"],
    cmd_bash = "sed -f $(SRCS) > $@",
)

genrule(
    name = "gen_syscall.h",
    srcs = [
        "arch/x86_64/bits/syscall.h.in",
    ],
    outs = ["syscall.h"],
    cmd_bash = "sed -n -e s/__NR_/SYS_/p < $< >> $@",
)

genrule(
    name = "gen_version.h",
    outs = ["version.h"],
    cmd_bash = "printf \"#define VERSION \"\"\" > $@",
)

cc_library(
    name = "gen_bits_headers",
    hdrs = [
        ":gen_alltypes.h",
        ":gen_syscall.h",
    ],
    include_prefix = "bits",
)

cc_library(
    name = "gen_headers",
    hdrs = [":gen_version.h"],
    deps = [":gen_bits_headers"],
)

cc_library(
    name = "musl",
    srcs = glob([
        "src/*.c",
        "src/math/x86_64/**/*.c",
    ]),
    hdrs = glob([
        "include/**",
        "arch/x86_64/**/*.h",
        "arch/generic/**/*.h",
        "src/internal/**/*.h",
        "src/include/**/*.h",
        "src/math/fma.c",
        "src/math/fmaf.c",
    ]),
    copts = [
        "-std=c99",
        "-nostdinc",
        "-ffreestanding",
        "-Os",
        "-pipe",
        "-fexcess-precision=standard",
        "-frounding-math",
        "-Wa,--noexecstack",
        "-fomit-frame-pointer",
        "-fno-unwind-tables",
        "-fno-asynchronous-unwind-tables",
        "-ffunction-sections",
        "-fdata-sections",
        "-fPIC",
    ],
    includes = [
        # Must be first!
        "src/include",
        "arch/generic",
        "arch/x86_64",
        "include",
        "src/internal",
        "src/math/x86_64",
    ],
    linkopts = ["-nostdlib"],
    linkstatic = True,
    local_defines = ["_XOPEN_SOURCE=700"],
    deps = [":gen_headers"],
)
