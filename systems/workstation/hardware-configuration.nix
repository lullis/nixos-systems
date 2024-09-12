# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.loader.systemd-boot.enable = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "amdgpu"];
  boot.extraModulePackages = [ ];


  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1d097df4-41b5-456d-99e2-72e298ff9792";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7C9E-D631";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/974e449b-dbf2-48a9-a74d-731f748ef3e6";
      fsType = "ext4";
    };

# UUID= /mnt/disks/disk1	btrfs rw,relatime,space_cache,subvolid=5,subvol=/	0	2
#  fileSystems."/mnt/disks/disk1" = {
#    device = "/dev/disk/by-uuid/935dc783-8741-4d71-b1e8-2cb47dfc820f";
#    fsType = "btrfs";
#    options = ["subvol=/"];
#  };

#  fileSystems."/mnt/disks/disk2" =
#    { device = "/dev/disk/by-uuid/504f5e3e-c49c-4272-a830-4ce3ee9e0f50";
#      fsType = "ext4";
#    };

 # fileSystems."/mnt/disks/disk3" = {
 #   device = "/dev/disk/by-uuid/9ea634ea-f98d-42b5-a6b3-abb55e32f635";
 #   fsType = "ext4";
 # };

  #fileSystems."/storage" = {
  #  fsType = "fuse.mergerfs";
  #  device = "/mnt/disks/disk*";
  #  options = ["cache.files=partial" "dropcacheonclose=true" "category.create=mfs"];
  #};

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
