load(":cc_toolchain_config.bzl", "cc_toolchain_config_osdev")

filegroup(name = "empty")

cc_toolchain(
    name = "cc_toolchain",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":cc_toolchain_config",
    toolchain_identifier = "os_toolchain",
)

cc_toolchain_config_osdev(name = "cc_toolchain_config")

toolchain(
    name = "clang_toolchain",
    exec_compatible_with = [
        "@platforms//os:none",
    ],
    target_compatible_with = [
        "@platforms//os:none",
    ],
    toolchain = ":cc_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "default_linux_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
    ],
    toolchain = "@local_config_cc//:cc-compiler-k8",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "default_macos_toolchain",
    exec_compatible_with = [
        "@platforms//os:macos",
    ],
    target_compatible_with = [
        "@platforms//os:macos",
    ],
    toolchain = "@local_config_cc//:cc-compiler-k8",  # TODO: Use native ARM for Mac M1/M2...?
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
