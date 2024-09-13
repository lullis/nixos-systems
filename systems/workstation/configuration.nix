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

  services.ollama = {
     enable = true;
     acceleration = "rocm";
     home = "/home/ollama";
     models = "/home/ollama/models";
     environmentVariables = {
       ROC_ENABLE_PRE_VEGA = "1";
       HSA_OVERRIDE_GFX_VERSION = "11.0.0";
     };
   };
}
