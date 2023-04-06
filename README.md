# Getting started

This is a ready to go template for x86\_64 hobby OS development using [bazel](https://bazel.build) as a build system.

It provides the following components:

- [musl](https://musl.libc.org/) as a LIBC
- [limine](https://github.com/limine-bootloader/limine) as a UEFI/BIOS bootloader
- [ia32](https://github.com/ia32-doc/ia32-doc) for all the definitions from the _Intel Manual_
- [liballoc](https://github.com/blanham/liballoc) as a simple malloc implementation (You still have to implement your own low level memory allocator!)

This template was tested successfully on:
- Ubuntu 22.04 LTS
- MacBook Pro M1 (Ventura 13.2.1)

# Setting up the environment

We use [Nix](https://nixos.org/) to guarantee a deterministic and reproducible build environment.

[Install Nix](https://nixos.org/download.html) and then run:

```
$ nix-shell --pure
```

# Build

## On macOS

Use the `--config mac` when you invoke `bazel build` like so:

```
$ bazelisk build --config mac //:compdb //:boot_iso
```

## On Linux

Use the `--config linux` when you invoke `bazel build` like so:

```
$ bazelisk build --config linux //:compdb //:boot_iso
```

# Bazel Targets

The `//:compdb` target generates the `compilation_commands.json` file.
The `//:boot_iso` target generates the bootable ISO image.

# Run

```
$ qemu-system-x86_64 -M q35 -m 2G -cdrom ./bazel-bin/barebones.iso -boot d
```
