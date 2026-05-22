{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/workstation.nix
      ../../roles/laptop.nix
      ../../roles/office.nix
      ../../hardware/lenovo/thinkpad/t14/intel/gen6/default.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-577f8c59-41f5-4c4d-a25c-3ac4ca221a73".device = "/dev/disk/by-uuid/577f8c59-41f5-4c4d-a25c-3ac4ca221a73";
  networking.hostName = "ion";
  networking.firewall.enable = false;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  system.stateVersion = "25.11";

  home-manager.users.raphael = {
    home.stateVersion = "25.11";
  };

  services.ollama = {
    enable = true;
  };

  services.llama-cpp = {
    modelsDir = "/var/lib/llama-cpp/models";
    port = 10000;
  };

}
