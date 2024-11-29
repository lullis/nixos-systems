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

  services.ollama = {
     enable = true;
     acceleration = "rocm";
     environmentVariables = {
       ROC_ENABLE_PRE_VEGA = "1";
       HSA_OVERRIDE_GFX_VERSION = "11.0.0";
     };
   };
}
