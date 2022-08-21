load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "flag_group",
    "flag_set",
    "tool",
    "tool_path",
)
load(
    "@bazel_tools//tools/cpp:toolchain_utils.bzl",
    "find_cpp_toolchain",
)
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

def toolchain_config_impl(ctx):
    # This feature adds -Wl,-S to the command line at the linking step
    # Since we invoke ld.lld directly, -Wl will not work
    features = [
        feature(
            name = "strip_debug_symbols",
            enabled = False,
        ),
    ]

    host_toolchain = find_cpp_toolchain(ctx)

    if "COMPILER_ABS_PATH" in ctx.configuration.default_shell_env:
        compiler_path = ctx.configuration.default_shell_env["COMPILER_ABS_PATH"]
    else:
        compiler_path = host_toolchain.compiler_executable

    if "LINKER_ABS_PATH" in ctx.configuration.default_shell_env:
        linker_path = ctx.configuration.default_shell_env["LINKER_ABS_PATH"]
    else:
        linker_path = host_toolchain.ld_executable

    tool_paths = [
        tool_path(
            name = "gcc",
            path = compiler_path,
        ),
        tool_path(
            name = "ld",
            path = linker_path,
        ),
        tool_path(
            name = "ar",
            path = host_toolchain.ar_executable,
        ),
        tool_path(
            name = "cpp",
            path = host_toolchain.preprocessor_executable,
        ),
        tool_path(
            name = "gcov",
            path = host_toolchain.gcov_executable,
        ),
        tool_path(
            name = "nm",
            path = host_toolchain.nm_executable,
        ),
        tool_path(
            name = "objdump",
            path = host_toolchain.objdump_executable,
        ),
        tool_path(
            name = "strip",
            path = host_toolchain.strip_executable,
        ),
    ]

    action_configs = [
        action_config(
            action_name = ACTION_NAMES.cpp_compile,
            enabled = True,
            flag_sets = [
                flag_set(
                    flag_groups = ([
                        flag_group(
                            flags = [
                                # Do not use the toolchain headers!
                                "-nostdinc",

                                # We use C++ 20
                                "-std=c++20",

                                # https://stackoverflow.com/questions/17692428/what-is-ffreestanding-option-in-gcc
                                # https://gcc.gnu.org/onlinedocs/gcc/Standards.html
                                "-ffreestanding",
                            ],
                        ),
                    ]),
                ),
            ],
            tools = [
                tool(path = compiler_path),
            ],
        ),
        action_config(
            action_name = ACTION_NAMES.cpp_link_executable,
            enabled = True,
            flag_sets = [
                flag_set(
                    flag_groups = ([
                        flag_group(
                            flags = [
                                "-nostdlib",
                            ],
                        ),
                    ]),
                ),
            ],
            tools = [
                tool(path = linker_path),
            ],
        ),
    ]

    compiler_type = "gcc" if "gcc" in compiler_path else "clang"

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        action_configs = action_configs,
        features = features,
        toolchain_identifier = "osdev_toolchain",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "x86_64",
        target_libc = "unknown",
        compiler = compiler_type,
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_toolchain_config_osdev = rule(
    implementation = toolchain_config_impl,
    attrs = {
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_host_toolchain")),
    },
    provides = [CcToolchainConfigInfo],
)
