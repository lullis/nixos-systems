{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/workstation.nix
      ../../roles/htpc.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "workstation";
  system.stateVersion = "23.11";
}
