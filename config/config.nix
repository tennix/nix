{pkgs}:

{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    binaryPackages = pkgs.buildEnv {
      name = "binary-packages";
      paths = [
        google-chrome
        slack
        teamviewer
        vscode
        zoom-us
      ];
    };
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        ansible
        awscli
        aws-iam-authenticator
        # azure-cli
        bat
        bitwarden-cli
        chez
        docker-machine-kvm2
        dropbox
        exa
        flameshot
        fstar
        ghc
        go
        google-cloud-sdk
        guile
        htop
        hugo
        icdiff
        jsonnet
        julia
        just
        kubectl
        kubernetes-helm
        minikube
        minishift
        nim
        nnn
        nodejs
        nox
        obs-studio
        ocaml
        ocamlPackages.utop
        opam
        python37
        rclone
        restic
        rustup
        skim                    # fuzzy finder in rust, /bin/sk
        terraform
        thunderbird
        tldr
        tokei
        weechat
        whois
        zeal
        zola
      ];
    };
  };
}
