{ config, pkgs, ... }:

{
  imports =
    [
      (import <home-manager/nixos>)
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/workstation.nix
      ../../roles/htpc.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "workstation";
  system.stateVersion = "24.05";

  home-manager.users.raphael = {
    home.stateVersion = "24.05";
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  services.ollama = {
     enable = true;
     acceleration = "rocm";
     environmentVariables = {
       ROC_ENABLE_PRE_VEGA = "1";
       HSA_OVERRIDE_GFX_VERSION = "11.0.0";
     };
   };

  services.kubo = {
    enable = true;
    settings = {
      Addresses = {
        AddrsListen = [ "/ip4/127.0.0.1/tcp/4001" ];
        API = "/ip4/127.0.0.1/tcp/5001";
        Gateway = "/ip4/127.0.0.1/tcp/4080";
      };
    };
  };
}
