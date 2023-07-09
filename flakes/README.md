# Nix Flakes

Use flake with direnv for per project development environment

## Project Setup

``` shell
nix flake init
# Copy language flake.nix into the project root directory
echo "use flake" > .envrc
direnv allow
```
