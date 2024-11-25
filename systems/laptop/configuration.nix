{ config, pkgs, ... }:

{
  imports =
    [
      (import <home-manager/nixos>)
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/workstation.nix
      ../../roles/laptop.nix
      ../../hardware/framework/13-inch/common/default.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework";

  system.stateVersion = "25.05";

  home-manager.users.raphael = {
    home.stateVersion = "25.05";
  };

  services.ollama = {
    enable = true;
  };
}
