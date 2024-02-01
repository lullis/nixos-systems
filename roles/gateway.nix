# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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

  hardware.enableRedistributableFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  networking.hostName = "gateway";
  networking.domain = "home.lullis.net";
  networking.defaultGateway = {
    address = "192.168.0.1";
    interface = "enp6s0";
  };
  networking.nameservers = [ "1.1.1.1" "4.2.2.1" ];


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


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
  };

  users.mutableUsers = false;

  # Define user accounts.
  users.users.raphael = {
    isNormalUser = true;
    hashedPassword = "$6$q5XmQWicUuay$u5S29deftinjHk2EVQ/bcgWOCjX7GSOD9IE4EiVcc1KhJjpL/uIm0L6Jp1ENROrlEtnl/1kOO5NOCr477aCS51";
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXnuZRQxLK5mtR74RfVXh2q8fGlR9p7jGHXYBj5FqTALUs61xC0aKvJj2HmTfTA9Hr3I7GptaXsky66YZmxIGqXtxjSDFksDEIUlKloS2IQYfR2I3NdVnFj4JUb5QcK4Q7SZUn23ftkY5zGGR1Y9btyW5APJn5FO8lT0hzr/8frorS8kzreUZhiLWPw2ij5AgBdGBbEtk05FBNZRDsjy4i4JDZ12oieb2oEaKTdXMmnyVfDtQesC3EvPL1QiGAf4a+Kx+VkCiW46jpgXSjRDoTVECf6nTqmoP7k+I7+z3TJPSxO+y2+w6mIkbsuYmoy8apHE05vvwQYH3KTxmrHFIx raphael@lullis.net"];

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     wget

     # Cluster / Orchestration
     docker
     nomad

     # Networking
     wireguard
     wireguard-tools

     # Wireless Access Point
     hostapd
     dnsmasq
     bridge-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.openssh = {
     enable = true;
     permitRootLogin = "yes";
  };

  system.stateVersion = "21.05";

}
