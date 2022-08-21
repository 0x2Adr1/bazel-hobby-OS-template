load(":cc_toolchain_config.bzl", "cc_toolchain_config_osdev")

filegroup(name = "empty")

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "x86_64": ":my_toolchain",
    },
)

cc_toolchain(
    name = "my_toolchain",
    toolchain_identifier = "my_toolchain",
    toolchain_config = ":my_toolchain_config",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
)

cc_toolchain_config_osdev(name = "my_toolchain_config")
