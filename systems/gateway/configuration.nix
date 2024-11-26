# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../roles/common.nix
      ../../roles/gateway.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  networking.hostName = "gateway";
  networking.defaultGateway = {
    address = "192.168.0.1";
    interface = "enp6s0";
  };

  # networking.wireless.interfaces.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  networking.firewall.enable = false;
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = false;
  networking.interfaces.enp5s0 = {
    useDHCP = false;
    ipv4 = {
      addresses = [{
        address = "192.168.1.10";
        prefixLength = 24;
      }];
    };
  };
  networking.interfaces.enp6s0 = {
    useDHCP = false;
    ipv4 = {
      addresses = [{
        address = "192.168.0.10";
        prefixLength = 24;
      }];
    };
  };

  networking.interfaces.wlp0s20u7.ipv4.addresses =
    lib.optionals config.services.hostapd.enable [{
      address = "192.168.1.11";
      prefixLength = 24;
    }];

  # networking.bridges.br0.interfaces = [ "enp5s0" "wlp0s20u7" ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     # Networking
     wireguard
     wireguard-tools

     # Wireless Access Point
     hostapd
     dnsmasq
     bridge-utils
  ];

  # List services that you want to enable:

  services.openssh = {
     enable = true;
     permitRootLogin = "yes";
  };

  services.hostapd = {
    enable = true;
    interface = "wlp0s20u7";
    hwMode = "g";
    ssid = "halkidiki";
    wpaPassphrase = "ellinida";
  };

  system.stateVersion = "21.05";

}
