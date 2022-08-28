# Getting started

This is a ready to go template for x86\_64 hobby OS development using [bazel](https://bazel.build) as a build system.

It provides the following components:

- [musl](https://musl.libc.org/) as a LIBC
- [limine](https://github.com/limine-bootloader/limine) as a UEFI/BIOS bootloader
- [ia32](https://github.com/ia32-doc/ia32-doc) for all the definitions from the _Intel Manual_
- [liballoc](https://github.com/blanham/liballoc) as a simple malloc implementation (You still have to implement your own low level memory allocator!)

This template was tested successfully on:
- Ubuntu 22.04 TLS with gcc-11.2.0 and llvm 14.0.0
- MacBook Pro M1 with llvm 14.0.6 installed with `brew`

## macOS

There is currently a [bug](https://github.com/bazelbuild/bazel/pull/15006) in bazel on macOS that prevents it to use `lld`.
So until the fix is merged, you need to recompile bazel with the patch above.

Fortunately, building bazel is quite [simple](https://bazel.build/install/compile-source).

```
$ brew install openjdk@11
$ sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
$ export JAVA_HOME=$(/usr/libexec/java_home -v11)

$ mkdir bazel_macos_fix
$ cd bazel_macos_fix
$ wget https://github.com/bazelbuild/bazel/releases/download/5.3.0/bazel-5.3.0-dist.zip
$ unzip bazel-5.3.0-dist.zip
$ wget https://gist.githubusercontent.com/0x2Adr1/27602f4b319681879aa8c28b085857f4/raw/3858297be9bd4bb54f43b0de4c4e3f381de67d82/bazel_5.3.0_macOS_lld.patch
$ patch -p0 < bazel_5.3.0_macOS_lld.patch
$ env EXTRA_BAZEL_ARGS="--tool_java_runtime_version=local_jdk" bash ./compile.sh

# Voila! You can find your new bazel binary under ./output/bazel
$ ./output/bazel --version
bazel 5.3.0- (@non-git)
```

## Install dependencies

Your system must have the following software installed:

- [xorriso](https://www.gnu.org/software/xorriso/)

**On macOS, you must install LLVM (and xorriso):**
- `$ brew install llvm xorriso`

# Using specific compiler and linker

By default the default toolchain installed on your host is used. But you can use a specific toolchain with the steps below.

**Note: macOS users must use the LLVM toolchain! Steps below are mandatory for you!**

Create a file `.bazelrc.user` at the root of the repo and add the content below:

```
build --action_env CXX="/opt/homebrew/opt/llvm/bin/clang"
build --action_env LD="/opt/homebrew/opt/llvm/bin/ld.lld"
build --action_env AR="/opt/homebrew/opt/llvm/bin/llvm-ar"
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
