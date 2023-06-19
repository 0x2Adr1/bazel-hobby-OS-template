load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

http_archive(
    name = "bazel_skylib",
    sha256 = "b8a1527901774180afc798aeb28c4634bdccf19c4d98e7bdd1ce79d1fe9aaad7",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.1/bazel-skylib-1.4.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

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
    tag = "v4.20230615.0-binary",
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
    strip_prefix = "musl-1.2.4",
    urls = ["https://git.musl-libc.org/cgit/musl/snapshot/musl-1.2.4.tar.gz"],
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
    "//:hobby_os_platform",
)

register_toolchains(
    "//toolchain:clang_toolchain",
    "//toolchain:default_linux_toolchain",
    "//toolchain:default_macos_toolchain",
)
