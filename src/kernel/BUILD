package(default_visibility = ["//visibility:public"])

cc_binary(
    name = "kernel",
    srcs = [
        "_start.cpp",
        "liballoc_hooks.cpp",
    ],
    additional_linker_inputs = [
        ":linker.ld",
    ],
    copts = [
        # Enable all warnings
        "-Wall",

        # Treat warning as error
        "-Werror",

        # Stop compilation at the first error
        "-Wfatal-errors",

        # Enable extra warnings
        "-Wextra",

        # We don't support C++ exceptions!
        "-fno-exceptions",

        # https://en.wikipedia.org/wiki/Run-time_type_information
        # We don't support C++ RTTI
        "-fno-rtti",
        "-ffreestanding",

        # https://mudongliang.github.io/2016/05/24/stack-protector.html
        "-fno-stack-protector",
        "-fno-stack-check",
        "-fno-pie",

        # https://en.wikipedia.org/wiki/Position-independent_code
        "-fno-pic",
        "-m64",
        "-march=x86-64",
        "-mabi=sysv",
        "-mno-80387",
        "-mno-mmx",
        "-mno-sse",
        "-mno-sse2",
        "-mno-red-zone",

        # We follow the Linux memory map (we map the kernel in the last 2GB)
        # Generate code for the kernel code model. The kernel runs in the negative 2 GB of the address space. This model has to be used for Linux kernel code.
        "-mcmodel=kernel",
    ],
    linkopts = [
        "-z max-page-size=4096",
        "-static",
        "--script=$(location :linker.ld)",
    ],
    deps = [
        "@ia32",
        "@liballoc",
        "@limine",
        "@musl",
    ],
)
