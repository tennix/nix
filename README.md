# My Nix configurations

I use NixOS in a Parallels VM, the system configuration files are in `nixos` directory.

For [dotfile management](https://github.com/tennix/dotfiles), I use [chezmoi](https://chezmoi.io) instead of [home-manager](https://github.com/nix-community/home-manager). I've used home-manager for several months, it causes more trouble than solving problems. Besides as I'm the only user for my nixos, installing software as normal user via home-manager makes no difference for installing globally.

I don't install programming language development tools globally, instead I use [Nix Flake](./flakes) for per project development environment setup.
