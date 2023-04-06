load("@com_grail_bazel_compdb//:defs.bzl", "compilation_database")
load("@com_grail_bazel_output_base_util//:defs.bzl", "OUTPUT_BASE")

package(default_visibility = ["//visibility:public"])

compilation_database(
    name = "compdb",
    # OUTPUT_BASE is a dynamic value that will vary for each user workspace.
    # If you would like your build outputs to be the same across users, then
    # skip supplying this value, and substitute the default constant value
    # "__OUTPUT_BASE__" through an external tool like `sed` or `jq` (see
    # below shell commands for usage).
    output_base = OUTPUT_BASE,
    targets = [
        "//src/kernel",
    ],
)

LINUX_GCC_LIB_DIR = "/nix/store/shasq3azl2298vqkvq5mc7vivdqp3yrj-gcc-12.2.0-lib/lib"

genrule(
    name = "boot_iso",
    srcs = [
        "//src/kernel",
        "//:limine.cfg",
        "@limine//:limine-cd.bin",
        "@limine//:limine-cd-efi.bin",
        "@limine//:limine.sys",
    ],
    outs = ["barebones.iso"],
    cmd_bash = """\
	            mkdir -p iso_root ;
	            cp $(location //src/kernel) \
                    $(location //:limine.cfg) \
                    $(location @limine//:limine.sys) \
                    $(location @limine//:limine-cd.bin) \
                    $(location @limine//:limine-cd-efi.bin) iso_root ;
	            xorriso -as mkisofs -b limine-cd.bin \
                    -no-emul-boot -boot-load-size 4 -boot-info-table \
		            --efi-boot limine-cd-efi.bin \
		            -efi-boot-part --efi-boot-image --protective-msdos-label \
		            iso_root -o $@ ; """ + select({
        "@platforms//os:none": "LD_LIBRARY_PATH={LINUX_GCC_LIB_DIR} $(location @limine//:limine-deploy) $@".format(LINUX_GCC_LIB_DIR = LINUX_GCC_LIB_DIR),
    }),
    tools = ["@limine//:limine-deploy"],
)

platform(
    name = "local_host_platform",
    parents = ["@local_config_platform//:host"],
)

platform(
    name = "hobby_os_platform",
    constraint_values = [
        "@platforms//os:none",
    ],
)
