{
    description = "HobbyOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/c47370e2cc335cb987577ff5fa26c9f29cc7774e";
        flake-utils.url = "github:numtide/flake-utils";
        flake-compat = {
            url = "github:edolstra/flake-compat";
            flake = false;
        };
    };

    outputs = { self, nixpkgs, flake-utils, ... }:
        flake-utils.lib.eachDefaultSystem (system: {
        devShell = (let
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
        in pkgs.mkShell {
            buildInputs = with pkgs; [
                bazelisk
                bazel-buildtools

                binutils
                coreutils-full
                curlFull

                stdenv.cc.cc.lib
                gcc-unwrapped.lib
                llvmPackages_15.llvm
                llvmPackages_15.libclang
                llvmPackages_15.libcxxabi
                lld_15

                git
                gnutar
                perl

                libiconv
                nixFlakes
                pkg-config
                which
                xcbuild
                xorriso
            ];

            shellHook = ''
                # patch binary from toybox breaks some of bazel repository rules when running `bazel sync`
                # override path to force use of gnupatch instead
                export PATH="${pkgs.gnupatch}/bin:''${PATH}"
                export WORKSPACE_ROOT="`pwd`"
                # Store debug output in a separate directory
                BAZEL_DEBUG="''${WORKSPACE_ROOT}/bazel-debug"
                if [ ! -d "''${BAZEL_DEBUG}" ]; then mkdir -p "''${BAZEL_DEBUG}"; fi
                source ${pkgs.bash-completion}/etc/profile.d/bash_completion.sh
            '';
        });
    });
}
