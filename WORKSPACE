load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

http_archive(
    name = "com_grail_bazel_compdb",
    strip_prefix = "bazel-compilation-database-0.5.2",
    urls = ["https://github.com/grailbio/bazel-compilation-database/archive/0.5.2.tar.gz"],
)

load("@com_grail_bazel_compdb//:deps.bzl", "bazel_compdb_deps")

bazel_compdb_deps()

new_git_repository(
    name = "limine",
    build_file = "//deps:limine.BUILD",
    remote = "https://github.com/limine-bootloader/limine.git",
    tag = "v4.20230330.0-binary",
)

new_git_repository(
    name = "ia32",
    branch = "main",
    build_file = "//deps:ia32.BUILD",
    remote = "https://github.com/ia32-doc/ia32-doc.git",
)

http_archive(
    name = "musl",
    build_file = "//deps:musl.BUILD",
    strip_prefix = "musl-1.2.3",
    urls = ["https://git.musl-libc.org/cgit/musl/snapshot/musl-1.2.3.tar.gz"],
)

http_archive(
    name = "liballoc",
    build_file = "//deps:liballoc.BUILD",
    patches = [
        "//deps:liballoc.patch",
    ],
    strip_prefix = "liballoc-1.1",
    urls = ["https://github.com/blanham/liballoc/archive/refs/tags/1.1.tar.gz"],
)

register_execution_platforms(
    "//:local_host_platform",
    "//:hobby_os_platform",
)

register_toolchains(
    "//toolchain:clang_toolchain",
    "//toolchain:default_linux_toolchain",
    "//toolchain:default_macos_toolchain",
)
