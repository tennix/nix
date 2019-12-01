# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  powerManagement.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_4_19;

  networking.hostName = "mac-nixos"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    unmanaged = [ "interface-name:docker0;interface-name:veth*" ];
  };
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # allow nixos container to use NAT to talk to outside network
  # networking.nat = {
  #   enable = true;
  #   internalInterfaces = ["ve-+"];
  #   externalInterface = "wlp3s0";
  # };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.extraHosts =
  ''
    127.0.0.1 localhost localhost.localdomain
    127.0.0.1 registry.localhost
  '';

  # Select internationalisation properties.
  i18n = {
    # consoleFont = "Lat2-Terminus16";
    # consoleKeyMap = "us";
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ table-other ];
    };
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ark
    aspell
    aspellDicts.en
    bind
    binutils
    bridge-utils
    clang
    cmake
    curl
    direnv
    docker
    docker_compose
    emacs
    fcitx
    fd
    file
    firefox
    gcc
    gdb
    git
    gnumake
    gnupg
    gopass
    graphviz
    gwenview
    httpie
    ispell
    jq
    kdeconnect
    linuxPackages.perf
    linuxPackages.virtualbox
    lldb
    lsof
    man-pages
    mutt
    mysql
    ncdu
    neofetch
    ntfs3g
    nixops
    nvi
    okular
    openssl
    openvpn
    p7zip
    pciutils
    plasma5.plasma-browser-integration
    powerline-go
    privoxy
    proxychains
    python27
    # (python27.withPackages(ps: with ps; [ websocket_client ])) # use as library for weechat slack
    qemu
    ripgrep
    rofi			# app launcher
    shadowsocks-libev
    shellcheck
    translate-shell		# command line translator
    unrar
    unzip
    usbutils
    vagrant
    valgrind
    vim
    virtmanager
    virtualbox
    vlc
    wget
    whois
    xclip
    yaml2json
    zsh
  ];

  fonts.fonts = with pkgs; [
    ubuntu_font_family
    source-code-pro
    wqy_microhei
    wqy_zenhei
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false; # docker swarm requires disabling live-restore
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;

  programs.dconf.enable = true; # for virt-manager to remember default hypervisor https://github.com/NixOS/nixpkgs/issues/42433
  programs.autojump.enable = true;
  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.autosuggestions.enable = true;
  programs.fish.enable = true;
  programs.command-not-found.enable = true;
  programs.less.enable = true;
  programs.tmux.enable = true;
  # programs.java.enable = true;
  # programs.npm.enable = true;
  # programs.vim.defaultEditor = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # add extra iptables for kdeconnect
  # networking.firewall.extraCommands = ''
  #   iptables -I INPUT -i wlp3s0 -p udp --dport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT
  #   iptables -I INPUT -i wlp3s0 -p tcp --dport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT

  #   iptables -A OUTPUT -o wlp3s0 -p udp --sport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT
  #   iptables -A OUTPUT -o wlp3s0 -p tcp --sport 1714:1764 -m state --state NEW,ESTABLISHED -j ACCEPT
  # '';
  networking.firewall.interfaces.wlp3s0.allowedTCPPortRanges = [
    { from = 1714; to = 1764; } # kdeconnect
  ];
  networking.firewall.interfaces.wlp3s0.allowedUDPPortRanges = [
    { from = 1714; to = 1764; } # kdeconnect
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # Enable bluetooth
  hardware.bluetooth.enable = true;
  # The facetimehd does not work
  # hardware.facetimehd.enable = true;

  systemd.services.disable-usb-wakeup = {
    description = "Disable USB wakeup triggers in /proc/acpi/wakeup";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/sh -c 'echo XHC1 > /proc/acpi/wakeup; echo ARPT > /proc/acpi/wakeup'";
      ExecStop = "${pkgs.bash}/bin/sh -c 'echo XHC1 > /proc/acpi/wakeup; echo ARPT > /proc/acpi/wakeup'";
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
  };

  systemd.services.suppress-gpe4E = {
    description = "Disable GPE 4E, an interrupt that is going crazy on Mac";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/sh -c 'echo disable > /sys/firmware/acpi/interrupts/gpe4E'";
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
  };

  systemd.services.shadowsocks-mc = {
    description = "Shadowsocks Client Service";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.shadowsocks-libev}/bin/ss-local -c /etc/shadowsocks/mc.json";
      Type = "simple";
      User = "nobody";
    };
  };

  systemd.services.shadowsocks-pc = {
    description = "Shadowsocks Client Service";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.shadowsocks-libev}/bin/ss-local -c /etc/shadowsocks/pc.json";
      Type = "simple";
      User = "nobody";
    };
  };

  # systemd.services.docker = { # override docker systemd service
  #   serviceConfig = {
  #     LimitNOFILE = 1024;
  #   };
  # };

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    privoxy = {
      enable = true;
      listenAddress = "0.0.0.0:8118";
      extraConfig = ''
        forward-socks5 / 0.0.0.0:1080 .
      '';
    };

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      # Enable touchpad support.
      libinput = {
        enable = true;
        naturalScrolling = true;
      };
      # Enable the KDE Desktop Environment.
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      windowManager.i3.enable = true;
    };

    #openvpn.servers = {
    #  officeVPN = { config = '' config /etc/vpn/office.ovpn ''; };
    #};

    flatpak = {
      enable = true;
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root.initialHashedPassword = "";
  users.users.tennix = {
    isNormalUser = true;
    home = "/home/tennix";
    extraGroups = ["wheel" "networkmanager" "docker" "tennix" "input" "libvirtd" "vboxusers"];
    uid = 1000;
  };
  users.groups.tennix.gid = 1000;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
