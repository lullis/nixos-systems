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
    systemd.user.services = {
      cloudflared = {
        Unit = {
          Description = "Cloudflare Tunnel";
          After = "docker.target";
        };
        Service = {
          StandardOutput = "journal";
          ExecStart = "${config.users.users.raphael.home}/.nix-profile/bin/docker-compose -f ${config.users.users.raphael.home}/projects/homelab/code/docker/cloudflared.yml up";
        };
      };
    };
  };

  services.ollama = {
    enable = true;
  };
}
