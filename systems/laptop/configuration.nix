{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/workstation.nix
      ../../roles/laptop.nix
      ../../hardware/framework/13-inch/common/default.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework";

  system.stateVersion = "24.05";

  services.ollama = {
    enable = true;
  };
}
