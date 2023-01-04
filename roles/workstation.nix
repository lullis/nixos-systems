{ pkgs, config, ... }:
let
  plainTextDir = "${config.users.users.raphael.home}/.secrets";
  encryptedDir = "${config.users.users.raphael.home}/.sync/vaults/gocryptfs";

  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz";
  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") { };

  python310Dev = pkgs.python310.withPackages (ps:
    with ps; [
      autopep8
      black
      epc
      flake8
      ipython
      isort
      jedi
      mypy
      poetry
      pip
      rope
      setuptools
      virtualenvwrapper
      yapf
      pip-tools
      keyring
      keyrings-alt
      secretstorage
    ]);

  ansible = pkgs.lib.overrideDerivation pkgs.python310Packages.ansible (oldAttrs: rec {
    propagatedBuildInputs = with pkgs.python310Packages; [
      resolvelib
      pycrypto
      paramiko
      jinja2
      pyyaml
      httplib2
      boto3
      botocore
      six
      netaddr
      setuptools
      dns
      hvac
    ];
  });
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
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config = {
    allowUnfree = true;
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


    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "intl";
      xkbOptions = "eurosign:e";
      libinput.enable = true;
      desktopManager.xfce.enable = true;
      displayManager.defaultSession = "xfce";
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
  ];

  nixpkgs.config.pulseaudio = true;

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

    home.packages = [
      # Base System Requirements
      pkgs.glibcLocales
      pkgs.gparted

      # Desktop Basics
      pkgs.fantasque-sans-mono
      # pkgs.lightlocker
      #pkgs.xdg-desktop-portal
      # pkgs.xdg-desktop-portal-gtk

      # Desktop tools
      pkgs.mate.mate-calc
      pkgs.drawio
      pkgs.vokoscreen-ng
      # pkgs.etcher
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
      python310Dev
      pkgs.rustup
      pkgs.go
      pkgs.yarn
      pkgs.nixfmt
      pkgs.nodejs-16_x
      pkgs.gcc
      pkgs.gnumake

      # Development
      pkgs.git
      pkgs.gitflow
      pkgs.hugo
      pkgs.pgformatter
      pkgs.robo3t

      # Devops
      ansible
      pkgs.docker-compose
      pkgs.vault
      pkgs.nomad
      pkgs.gitlab-runner
      pkgs.drone-cli
      pkgs.minikube
      pkgs.kubectl
      pkgs.awscli2
      pkgs.terraform
      pkgs.doppler

      # System Administration
      pkgs.apache-directory-studio

      # Remote work
      # pkgs.citrix_workspace

      # Password Manager and Encrypted Filesystems
      pkgs.pwgen
      pkgs.keepassxc
      pkgs.gocryptfs

      # Web
      pkgs.epiphany
      pkgs.brave
      pkgs.firefox-esr
      pkgs.newsflash

      # Email
      pkgs.thunderbird

      # Messaging apps
      pkgs.element-desktop
      pkgs.dino
      pkgs.slack

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

    programs.emacs = import ../programs/emacs.nix {pythonElpy = python310Dev;};
    programs.tmux = import ../programs/tmux.nix {tmuxPlugins = pkgs.tmuxPlugins;};
    # programs.zsh = import ../programs/zsh.nix;
    programs.git = import ../programs/git.nix;

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
      ExecStart = "/bin/sh -c '${pkgs.gocryptfs}/bin/gocryptfs --extpass=\"${python310Dev}/bin/keyring get login gocryptfs\" ${encryptedDir} ${plainTextDir}'";
      ExecStartPre = "/bin/sh -c '${pkgs.coreutils}/bin/mkdir -p ${plainTextDir}'";
      ExecStop = "/bin/sh -c 'fusermount -u ${plainTextDir}'";
    };
  };
}
