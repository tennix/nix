let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  nightlyRust = (nixpkgs.rustChannelOf {
    date = "2019-09-05";
    channel = "nightly";
  }).rust.override {
    extensions = [
      "clippy-preview"
      "rustfmt-preview"
    ];
  };
in
with nixpkgs;
stdenv.mkDerivation {
  name = "tikv_build_shell";
  buildInputs = [
    cmake
    gflags
    git
    nightlyRust
    openssl
    perl # openssl crate requires Perl for configuration
    pkgconfig
    protobuf
    rustup
    zlib
  ];
  shellHook = ''
        export OPENSSL_DIR="${openssl.dev}"
        export OPENSSL_LIB_DIR="${openssl.out}/lib"
        export PROTOC="${protobuf}/bin/protoc"
    '';
}
