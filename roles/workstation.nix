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
    ];
  };

  networking.networkmanager.enable = true;

  users.users.raphael = {
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
    shell = pkgs.bash;
  };

  virtualisation.docker.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  security.rtkit.enable = true;

  services = {
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
      layout = "us";
      xkbVariant = "intl";
      xkbOptions = "eurosign:e";
      libinput.enable = true;
      desktopManager.xfce.enable = true;
      displayManager.defaultSession = "xfce";
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
     python311Dev
  ];

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio.enable = false;
  # Sound configuration via pulseaudio
  # hardware.pulseaudio = {
  #   enable = true;
  #   configFile = pkgs.writeText "default.pa" ''
  #     # load-module module-bluetooth-policy
  #     # load-module module-bluetooth-discover
  #     load-module module-switch-on-connect
  #   '';
  # };

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
      pkgs.lightlocker
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk

      # Desktop tools
      pkgs.mate.mate-calc
      pkgs.drawio
      pkgs.vokoscreen-ng
      pkgs.etcher
      pkgs.transmission-gtk
      pkgs.gnome.gnome-disk-utility
      pkgs.gnome.seahorse

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

      # Programming
      pkgs.rustup
      pkgs.go
      pkgs.yarn
      pkgs.nixfmt
      pkgs.nodejs-18_x
      pkgs.gcc
      pkgs.gnumake
      pkgs.poetry

      # Development
      pkgs.git
      pkgs.gitflow
      pkgs.hugo
      pkgs.pgformatter
      pkgs.robo3t

      # Devops
      pkgs.docker-compose
      pkgs.vault
      pkgs.gitlab-runner
      pkgs.minikube
      pkgs.kubectl
      pkgs.awscli2
      pkgs.terraform
      pkgs.doppler

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
      pkgs.firefox-esr
      # pkgs.newsflash

      # Email
      pkgs.thunderbird

      # Messaging apps
      pkgs.element-desktop
      pkgs.dino
      pkgs.slack
      pkgs.tdesktop

      # Media Editors
      pkgs.gimp
      pkgs.inkscape
      pkgs.pitivi
      pkgs.handbrake

      # Media Managers
      pkgs.mkvtoolnix
      pkgs.youtube-dl
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
