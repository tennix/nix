import ./default.nix {
    crossSystem = (import <nixpkgs> {}).lib.systems.examples.musl64;
}
