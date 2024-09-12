{ pkgs, config, ... }:
let
  plainTextDir = "${config.users.users.raphael.home}/.secrets";
  encryptedDir = "${config.users.users.raphael.home}/.sync/vaults/gocryptfs";

  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };

  python311Dev = pkgs.python311.withPackages (ps:
    with ps; [
      ansible-core
      autopep8
      black
      boto3
      botocore
      docker
      epc
      flake8
      ipython
      isort
      jedi
      mypy
      pip
      rope
      setuptools
      virtualenvwrapper
      yapf
      pip-tools
      keyring
      keyrings-alt
      secretstorage
      hvac
      pywebpush
      hcloud
    ]);

  pythonElpy = pkgs.python310.withPackages (ps:
    with ps; [
      autopep8
      black
      epc
      flake8
      jedi
      mypy
      pip
      rope
      yapf
      setuptools
      isort
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

  users.users.raphael = {
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "scanner" "lp"];
    shell = pkgs.bash;
  };

  virtualisation.docker.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  hardware = {
    pulseaudio.enable = false;

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
    thunar.plugins = [
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-media-tags-plugin
    ];
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    displayManager = {
      defaultSession = "xfce";
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

    syncthing = {
      enable = true;
      user = "raphael";
      configDir="/home/raphael/.config/syncthing";
    };

    geoclue2 = {
      enable = true;
    };

    localtimed = {
      enable = true;
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
    printing.enable = true;
  };

  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
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
     python311Dev
  ];

  nixpkgs.config.pulseaudio = true;



  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.raphael = {
    imports = [
      nur.repos.rycee.hmModules.emacs-init
    ];

    home.stateVersion = "23.05";
    home.packages = [
      # Base System Requirements
      pkgs.glibcLocales
      pkgs.gparted
      pkgs.unzip

      # Desktop Basics
      pkgs.fantasque-sans-mono
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk

      # Desktop tools
      pkgs.mate.mate-calc
      pkgs.mate.atril
      pkgs.drawio
      pkgs.vokoscreen-ng
      # pkgs.etcher
      pkgs.transmission-gtk
      pkgs.gnome.gnome-disk-utility
      pkgs.gnome.seahorse
      pkgs.gnome.simple-scan

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
      pkgs.rustup
      pkgs.go
      pkgs.yarn
      pkgs.bun
      pkgs.nixfmt-classic
      pkgs.nodejs-18_x
      pkgs.corepack_22
      pkgs.gcc
      pkgs.gnumake
      pkgs.poetry
      pkgs.pre-commit
      pkgs.git
      pkgs.gitflow
      pkgs.hugo
      pkgs.pgformatter
      pkgs.robo3t

      # Devops
      pkgs.docker-compose
      pkgs.vault-bin
      pkgs.hcloud
      pkgs.gitlab-runner
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

      # Password Manager and Encrypted Filesystems
      pkgs.pwgen
      pkgs.keepassxc
      pkgs.kpcli

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
      pkgs.handbrake

      # Media Managers
      pkgs.mkvtoolnix
      pkgs.yt-dlp
      pkgs.beets

      # Media players
      pkgs.vlc
      pkgs.ffmpeg
      pkgs.rhythmbox
    ];

    programs.emacs = import ../programs/emacs.nix {pythonElpy = pythonElpy;};
    programs.tmux = import ../programs/tmux.nix {tmuxPlugins = pkgs.tmuxPlugins;};
    programs.git = import ../programs/git.nix;
    programs.alacritty = import ../programs/alacritty.nix;

    xresources.properties = {
      # Set some Emacs GUI properties in the .Xresources file because they are
      # expensive to set during initialization in Emacs lisp. This saves about
      # half a second on startup time. See the following link for more options:
      # https://www.gnu.org/software/emacs/manual/html_node/emacs/Fonts.html#Fonts
      "Emacs.menuBar" = false;
      "Emacs.toolBar" = false;
      "Emacs.verticalScrollBars" = false;
    };
  };


  programs.nm-applet.enable = true;
  programs.nm-applet.indicator = true;

  systemd.user.services.gocryptfs = {
    unitConfig = {
      Description = "Encrypted Secrets File Mount";
      After = "local-fs.target";
    };
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      StandardOutput = "journal";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/gocryptfs --extpass=\"${python311Dev}/bin/keyring get login gocryptfs\" ${encryptedDir} ${plainTextDir}";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${plainTextDir}";
      ExecStop = "/run/wrappers/bin/fusermount -u ${plainTextDir}";
    };
  };
}
