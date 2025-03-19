{ pkgs, config, ... }:
let
  plainTextDir = "${config.users.users.raphael.home}/.secrets";
  encryptedDir = "${config.users.users.raphael.home}/.sync/vaults/gocryptfs";

  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };

  python312Dev = pkgs.python312.withPackages (ps:
    with ps; [
      ansible-core
      autopep8
      base58
      black
      boto3
      botocore
      docker
      dunamai
      epc
      fastecdsa
      flake8
      ipython
      isort
      jedi
      mypy
      pip
      pylint
      rope
      setuptools
      virtualenvwrapper
      yapf
      pip-tools
      keyring
      keyrings-alt
      secretstorage
      signedjson
      hvac
      pywebpush
      hcloud
      tree-sitter
      poetry-dynamic-versioning
      python-lsp-server
      python-lsp-black
      pylsp-rope
      pylsp-mypy
      pyls-isort
      pyls-flake8
      ruff
    ]);
in
{
  imports = [
    (import <home-manager/nixos>)
  ];

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-19.1.9"
      "vault-bin-1.15.6"
    ];
  };

  networking.networkmanager.enable = true;
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      userland-proxy = false;
      experimental = true;
      metrics-addr = "0.0.0.0:9323";
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.hplipWithPlugin ];
    };

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  security.rtkit.enable = true;

  programs = {
    file-roller.enable = true;
    thunar.plugins = [
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-media-tags-plugin
      pkgs.xfce.thunar-volman
    ];

    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    libinput = {
      enable = true;
    };

    printing = {
      enable = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      drivers = [
        pkgs.hplipWithPlugin
      ];
    };

    pulseaudio.enable = false;

    syncthing = {
      enable = true;
      user = "raphael";
      configDir = "/home/raphael/.config/syncthing";
    };

    geoclue2 = {
      enable = true;
    };

    localtimed = {
      enable = true;
    };

    displayManager = {
      enable = true;
      defaultSession = "xfce";
    };

    xserver = {
      enable = true;
      xkb = {
        variant = "intl";
        options = "eurosign:e";
        layout = "us";
      };
      desktopManager.xfce.enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };

    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
  };

  environment.systemPackages = with pkgs; [
     pkgs.pulseaudio
     pkgs.pavucontrol
     pkgs.traceroute
     pkgs.whois
     pkgs.vim
     pkgs.gocryptfs
     pkgs.xfce.xfce4-weather-plugin
     pkgs.xfce.xfce4-whiskermenu-plugin
     pkgs.xfce.xfce4-pulseaudio-plugin
     pkgs.xfce.xfce4-icon-theme
     pkgs.xfce.xfwm4-themes
     pkgs.greybird
     pkgs.pop-icon-theme
     pkgs.papirus-icon-theme
     pkgs.paper-icon-theme
     pkgs.pantheon.elementary-icon-theme
     pkgs.numix-icon-theme-square
     pkgs.elementary-xfce-icon-theme
     pkgs.arc-icon-theme
     pkgs.arc-theme
     pkgs.hplip
     python312Dev
  ];

  nixpkgs.config.pulseaudio = true;

  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.raphael = {
    imports = [
      nur.repos.rycee.hmModules.emacs-init
    ];

    home.packages = [
      # Base System Requirements
      pkgs.glibcLocales
      pkgs.gparted
      pkgs.unzip
      # pkgs.archiver

      # Desktop Basics
      pkgs.fantasque-sans-mono
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      pkgs.xarchiver

      # Desktop tools
      pkgs.mate.mate-calc
      pkgs.mate.atril
      # pkgs.drawio
      pkgs.vokoscreen-ng
      # pkgs.etcher
      pkgs.transmission_4-gtk
      pkgs.gnome-disk-utility
      pkgs.seahorse
      pkgs.simple-scan

      # Office Tools
      pkgs.libreoffice-qt
      pkgs.hunspell

      # Console tools
      pkgs.htop
      pkgs.neofetch
      pkgs.silver-searcher
      pkgs.ripgrep
      pkgs.fd
      pkgs.jq
      pkgs.alacritty
      pkgs.httpie

      # Software Development
      pkgs.direnv
      pkgs.rustup
      pkgs.go
      pkgs.yarn
      pkgs.bun
      pkgs.nixfmt-classic
      pkgs.nodejs_22
      pkgs.corepack_22
      pkgs.gcc
      pkgs.gnumake
      pkgs.poetry
      pkgs.uv
      pkgs.pre-commit
      pkgs.git
      pkgs.gitflow
      pkgs.hugo
      pkgs.pgformatter
      pkgs.robo3t
      pkgs.tree-sitter
      pkgs.zed-editor
      pkgs.typescript-language-server
      pkgs.vue-language-server
      pkgs.gopls
      pkgs.godef
      pkgs.gettext

      # Devops
      pkgs.docker-compose
      pkgs.vault-bin
      pkgs.hcloud
      pkgs.gitlab-runner
      pkgs.gitlab-ci-local
      pkgs.woodpecker-cli
      pkgs.minikube
      pkgs.kubectl
      pkgs.awscli2
      pkgs.terraform
      pkgs.doppler
      pkgs.minio-client
      pkgs.openssl

      # networking
      pkgs.cloudflared

      # System Administration
      pkgs.apache-directory-studio
      # pkgs.synadm

      # Password Manager and Encrypted Filesystems
      pkgs.pwgen
      pkgs.keepassxc
      pkgs.gnome-secrets
      pkgs.kpcli
      pkgs.libsecret

      # Web
      pkgs.epiphany
      pkgs.brave
      pkgs.firefox
      pkgs.newsflash

      # Email
      pkgs.thunderbird

      # Messaging apps
      pkgs.element-desktop
      pkgs.zoom-us
      pkgs.dino
      pkgs.slack
      pkgs.tdesktop
      pkgs.discord
      pkgs.fractal

      # Media Editors
      pkgs.gimp
      pkgs.inkscape
      pkgs.pitivi
      # pkgs.handbrake

      # Media Managers
      pkgs.mkvtoolnix
      pkgs.yt-dlp
      pkgs.beets

      # Media players
      pkgs.vlc
      pkgs.ffmpeg
      pkgs.rhythmbox
    ];

    programs.emacs = import ../programs/emacs.nix {};
    programs.tmux = import ../programs/tmux.nix {tmuxPlugins = pkgs.tmuxPlugins;};
    programs.git = import ../programs/git.nix;
    programs.alacritty = import ../programs/alacritty.nix;
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
    };

    xresources.properties = {
      # Set some Emacs GUI properties in the .Xresources file because they are
      # expensive to set during initialization in Emacs lisp. This saves about
      # half a second on startup time. See the following link for more options:
      # https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
      "Emacs.menuBar" = false;
      "Emacs.toolBar" = false;
      "Emacs.verticalScrollBars" = false;
    };

    systemd.user.services = {
      gocryptfs = {
        Unit = {
          Description = "Encrypted Secrets File Mount";
          After = "graphical-session.target";
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          Type = "oneshot";
          StandardOutput = "journal";
          RemainAfterExit = true;
          ExecStart = "/run/current-system/sw/bin/gocryptfs --extpass=\"secret-tool lookup gocryptfs masterpassword\" ${encryptedDir} ${plainTextDir}";
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${plainTextDir}";
          ExecStop = "/run/wrappers/bin/fusermount -u ${plainTextDir}";
        };
      };
    };
  };

  programs.nm-applet.enable = true;
  programs.nm-applet.indicator = true;
  programs.ssh.startAgent = true;
}
