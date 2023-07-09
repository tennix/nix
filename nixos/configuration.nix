# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos-intel"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
    trusted-users = [ "root" "tennix" ];
    # nix options for derivations to persist garbage collection
    keep-outputs = true;
    keep-derivations = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_CTYPE = "zh_CN.UTF-8";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons fcitx5-gtk ];
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tennix = {
    isNormalUser = true;
    description = "tennix";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      nix-direnv = super.nix-direnv.override { enableFlakes = true; };
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    alacritty
    argocd
    awscli2
    bat
    bitwarden-cli
    cachix
    cfssl
    chezmoi
    cmake
    delta
    dig
    direnv
    (import (fetchTarball
      "https://github.com/cachix/devenv/archive/v0.6.3.tar.gz")).default
    emacs
    docker
    docker-buildx
    docker-compose
    fd
    file
    firefox
    fzf
    (google-cloud-sdk.withExtraComponents
      [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    git
    gost
    helix
    jq
    kind
    kitty
    kubectl
    kubernetes-helm
    kustomize
    kubectx
    lazygit
    ncdu
    neofetch
    neovim
    nix-direnv
    nixfmt
    nyxt
    mysql
    onefetch
    openssl
    polybar
    postgresql
    pulumi
    (python3.withPackages (ps: with ps; [ epc openai six sexpdata ]))
    ripgrep
    rofi
    shadowsocks-libev
    shellcheck
    sqlite
    ssm-session-manager-plugin
    starship
    tmux
    tokei
    tree
    unzip
    wasmtime
    wget
    zellij
    wezterm
    zsh
    zola
  ];

  # Enable zsh completion for system packages (e.g. systemd)
  environment.pathsToLink = [ "/share/zsh" "/share/nix-direnv" ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.autojump.enable = true;
  programs.command-not-found.enable = true;
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
  # programs.starship.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  programs.nix-ld.enable = true;

  # List services that you want to enable:
  # Enable docker daemon
  virtualisation.docker.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ i3lock rofi polybar ];
    };
  };
  # Enable picom compositing manager
  services.picom.enable = true;
  services.tailscale.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
