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
  networking.firewall.enable = false;
  networking.nameservers = [
    "1.1.1.1" "4.2.2.1"
  ];

  system.stateVersion = "25.05";

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    "userland-proxy" = true;
  };

  home-manager.users.raphael = {
    home.stateVersion = "25.05";
  };

  services.ollama = {
    enable = true;
  };
}
