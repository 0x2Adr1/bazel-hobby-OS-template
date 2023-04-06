load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "flag_group",
    "flag_set",
    "tool",
    "tool_path",
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

    mac_toolchain_tools = {
        "CXX": "/nix/store/4hs6da0ihz147wl8yyqhw12ymb3rjz0z-clang-15.0.7/bin/clang-15",
        "LD": "/nix/store/qii1yq15asjnlr3l7a652dxkm28vhs5d-lld-15.0.7/bin/ld.lld",
        "AR": "/nix/store/485bq8n1s649znxgi9wvq88wqgm9pn1r-llvm-15.0.7/bin/llvm-ar",
    }

    linux_toolchain_tools = {
        "CXX": "/nix/store/hhgbk0gvfml5z5y4y5g9f7qrk7a4cbx6-clang-15.0.7/bin/clang-15",
        "LD": "/nix/store/45x7bvx5sywsha7pmg19x1vkvg69zbbi-lld-15.0.7/bin/ld.lld",
        "AR": "/nix/store/5k596flfwq7aa3s15s0qkxx7xkgpg2cj-llvm-15.0.7/bin/llvm-ar",
        "CPP": "/nix/store/h5003wsy3qqimqvrkn3bc5mwq4hhidag-gcc-wrapper-12.2.0/bin/cpp",
        "GCOV": "/nix/store/p975i9blgmkjfxpnlvdmm0xvjg573b6l-gcc-12.2.0/bin/gcov",
        "NM": "/nix/store/5k596flfwq7aa3s15s0qkxx7xkgpg2cj-llvm-15.0.7/bin/llvm-nm",
        "OBJDUMP": "/nix/store/485bq8n1s649znxgi9wvq88wqgm9pn1r-llvm-15.0.7/bin/llvm-objdump",
        "STRIP": "/nix/store/485bq8n1s649znxgi9wvq88wqgm9pn1r-llvm-15.0.7/bin/llvm-strip",
    }

    toolchain_tools = linux_toolchain_tools

    compiler_type = "clang-15.0.7"

    tool_paths = [
        tool_path(
            name = "gcc",
            path = toolchain_tools["CXX"],
        ),
        tool_path(
            name = "ld",
            path = toolchain_tools["LD"],
        ),
        tool_path(
            name = "ar",
            path = toolchain_tools["AR"],
        ),
        tool_path(
            name = "cpp",
            path = toolchain_tools["CPP"],
        ),
        tool_path(
            name = "gcov",
            path = toolchain_tools["GCOV"],
        ),
        tool_path(
            name = "nm",
            path = toolchain_tools["NM"],
        ),
        tool_path(
            name = "objdump",
            path = toolchain_tools["OBJDUMP"],
        ),
        tool_path(
            name = "strip",
            path = toolchain_tools["STRIP"],
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

        # We use limine's terminal feature which is now deprecated...
        "-Wno-error=deprecated-declarations",
    ]

    if "clang" in compiler_type:
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
                tool(path = toolchain_tools["CXX"]),
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
                tool(path = toolchain_tools["CXX"]),
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
                tool(path = toolchain_tools["LD"]),
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
                tool(path = toolchain_tools["AR"]),
            ],
        ),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        action_configs = action_configs,
        features = features,
        toolchain_identifier = "os_toolchain",
        target_system_name = "unknown",
        target_cpu = "x86_64",
        target_libc = "unknown",
        compiler = compiler_type,
        tool_paths = tool_paths,
    )

cc_toolchain_config_osdev = rule(
    implementation = toolchain_config_impl,
    provides = [CcToolchainConfigInfo],
)
