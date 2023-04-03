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

    toolchain_tools = {
        "CXX": host_toolchain.compiler_executable,
        "LD": host_toolchain.ld_executable,
        "AR": host_toolchain.ar_executable,
    }

    for k in toolchain_tools.keys():
        if k in ctx.configuration.default_shell_env:
            toolchain_tools[k] = ctx.configuration.default_shell_env[k]

    compiler_executable = toolchain_tools["CXX"]
    linker_executable = toolchain_tools["LD"]
    ar_executable = toolchain_tools["AR"]

    compiler_type = "gcc" if "gcc" in compiler_executable else "clang"

    tool_paths = [
        tool_path(
            name = "gcc",
            path = compiler_executable,
        ),
        tool_path(
            name = "ld",
            path = linker_executable,
        ),
        tool_path(
            name = "ar",
            path = ar_executable,
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

    common_compilation_flags = [
        # Do not use the toolchain headers!
        "-nostdinc",

        # https://stackoverflow.com/questions/17692428/what-is-ffreestanding-option-in-gcc
        # https://gcc.gnu.org/onlinedocs/gcc/Standards.html
        "-ffreestanding",

        # Enable all warnings
        "-Wall",

        # Treat warning as error
        "-Werror",

        # Stop compilation at the first error
        "-Wfatal-errors",

        # Enable extra warnings
        "-Wextra",
    ]

    if compiler_type == "clang":
        common_compilation_flags.append("--target=x86_64-pc-none-elf")

    action_configs = [
        action_config(
            action_name = ACTION_NAMES.c_compile,
            enabled = True,
            flag_sets = [
                flag_set(
                    flag_groups = ([
                        flag_group(
                            flags = [
                                "-std=c11",
                            ] + common_compilation_flags,
                        ),
                    ]),
                ),
            ],
            tools = [
                tool(path = compiler_executable),
            ],
        ),
        action_config(
            action_name = ACTION_NAMES.cpp_compile,
            enabled = True,
            flag_sets = [
                flag_set(
                    flag_groups = ([
                        flag_group(
                            flags = [
                                "-std=c++2b",
                            ] + common_compilation_flags,
                        ),
                    ]),
                ),
            ],
            tools = [
                tool(path = compiler_executable),
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
                tool(path = linker_executable),
            ],
        ),
        action_config(
            action_name = ACTION_NAMES.cpp_link_static_library,
            enabled = True,
            flag_sets = [
                flag_set(
                    flag_groups = ([
                        flag_group(flags = ["rcsD"]),
                        flag_group(
                            flags = ["%{output_execpath}"],
                            expand_if_available = "output_execpath",
                        ),
                    ]),
                ),
                flag_set(
                    flag_groups = [
                        flag_group(
                            iterate_over = "libraries_to_link",
                            flag_groups = [
                                flag_group(
                                    flags = ["%{libraries_to_link.name}"],
                                ),
                            ],
                            expand_if_available = "libraries_to_link",
                        ),
                    ],
                ),
            ],
            tools = [
                tool(path = ar_executable),
            ],
        ),
    ]

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
