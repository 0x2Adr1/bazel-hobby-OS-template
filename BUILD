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
		            iso_root -o $@ ;
	            $(location @limine//:limine-deploy) $@""",
    tools = ["@limine//:limine-deploy"],
)
