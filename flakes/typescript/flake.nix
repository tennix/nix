{
  description = "TypeScript development environment";

  nixConfig.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];

  inputs = { nixpkgs.url = "nixpkgs/nixos-23.05"; };

  outputs = { self, nixpkgs }:
    let
      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in {
      # Add dependencies that are only needed for development
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs
              nodePackages.typescript
              nodePackages.typescript-language-server
            ];
          };
        });
    };
}
