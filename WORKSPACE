load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

http_archive(
    name = "com_grail_bazel_compdb",
    strip_prefix = "bazel-compilation-database-0.5.2",
    urls = ["https://github.com/grailbio/bazel-compilation-database/archive/0.5.2.tar.gz"],
)

load("@com_grail_bazel_compdb//:deps.bzl", "bazel_compdb_deps")

bazel_compdb_deps()

http_archive(
    name = "limine",
    build_file = "//deps:limine.BUILD",
    strip_prefix = "limine-3.16.2-binary",
    urls = ["https://github.com/limine-bootloader/limine/archive/refs/tags/v3.16.2-binary.tar.gz"],
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

# Nix
http_archive(
    name = "io_tweag_rules_nixpkgs",
    strip_prefix = "rules_nixpkgs-140abffc482fe4610eab261f5b7da97c142b3e94",
    urls = ["https://github.com/tweag/rules_nixpkgs/archive/140abffc482fe4610eab261f5b7da97c142b3e94.tar.gz"],
)
