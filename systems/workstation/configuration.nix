{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/workstation.nix
      ../../roles/htpc.nix
      ../../roles/office.nix
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
  };

  services.ollama = {
     enable = true;
     package = pkgs.ollama-rocm;
     host = "0.0.0.0";
     environmentVariables = {
       ROC_ENABLE_PRE_VEGA = "1";
       HSA_OVERRIDE_GFX_VERSION = "11.0.0";
     };
   };

  systemd.user.services.open-webui = {
    Unit = {
      Description = "Open WebUI";
      After = "graphical-session.target";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
    Service = {
      StandardOutput = "journal";
      ExecStart = "${config.users.users.raphael.home}/.nix-profile/bin/open-webui serve --host 0.0.0.0 --port 8765";
      Environment = [
        "WEBUI_SECRET_KEY=${config.users.users.raphael.home}/.openwebui/secret_key"
        "OLLAMA_API_BASE_URL=http://0.0.0.0:11434"
        "WEBUI_AUTH=False"
        "ANONYMIZED_TELEMETRY=False"
        "DO_NOT_TRACK=True"
        "SCARF_NO_ANALYTICS=True"
        "FRONTEND_BUILD_DIR=${config.users.users.raphael.home}/.openwebui/frontend"
        "DATA_DIR=${config.users.users.raphael.home}/.openwebui/data"
      ];
    };
  };

  services.kubo = {
    enable = true;
    settings = {
      API.HTTPHeaders = {
        "Access-Control-Allow-Origin" = [ "*" ];
        "Access-Control-Allow-Methods" = [ "GET" "POST" "OPTIONS" ];
      };
      Addresses = {
        AddrsListen = [ "/ip4/127.0.0.1/tcp/4001" ];
        API = "/ip4/127.0.0.1/tcp/5001";
        Gateway = "/ip4/127.0.0.1/tcp/4080";
      };
    };
  };
}
