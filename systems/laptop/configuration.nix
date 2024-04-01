{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/workstation.nix
      ../../roles/laptop.nix
      ../../hardware/framework/default.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework";

  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  system.stateVersion = "22.05";
}
