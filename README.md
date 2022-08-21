# Getting started

This is a ready to go template for x86\_64 hobby OS development using [bazel](https://bazel.build) as a build system.

It provides the following components:

- [musl](https://musl.libc.org/) as a LIBC
- [limine](https://github.com/limine-bootloader/limine) as a UEFI/BIOS bootloader
- [ia32](https://github.com/ia32-doc/ia32-doc) for all the definitions from the _Intel Manual_
- [liballoc](https://github.com/blanham/liballoc) as a simple malloc implementation (You still have to implement your own low level memory allocator!)

This template was tested successfully on Ubuntu 22.04 TLS with gcc-11.2.0 and clang-14.0.0.

Macbook M1 (ARM) isn't supported yet, but once https://github.com/bazelbuild/bazel/pull/15006 is merged it should be easy to make it work.

## Install dependencies

Your system must have the following software installed:

- [xorriso](https://www.gnu.org/software/xorriso/)
- [bazel](https://bazel.build/install/bazelisk)

# Using specific compiler and linker

By default the default toolchain installed on your host is used.
But if you need to use a specific compiler and linker this is how you do it:

Create a file `.bazelrc.user` at the root of the repo and add the content below:

```
build --action_env="COMPILER_ABS_PATH=<absolute path to the compiler>"
build --action_env="LINKER_ABS_PATH=<absolute path to the linker>"
```

For example:

```
build --action_env="COMPILER_ABS_PATH=/usr/bin/clang-14"
build --action_env="LINKER_ABS_PATH=/usr/bin/ld.lld-14"
```

# Build

```
$ bazel build //:compdb //:boot_iso
```

The `//:compdb` target generates the `compilation_commands.json` file.
The `//:boot_iso` target generates the bootable ISO image.

# Run

```
$ qemu-system-x86_64 -M q35 -m 2G -cdrom ./bazel-bin/barebones.iso -boot d
```
