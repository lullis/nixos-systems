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
  system.stateVersion = "22.05";
}
