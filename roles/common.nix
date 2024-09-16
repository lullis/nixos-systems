{ pkgs, ... }:
let
  credentials = {
    hashedPassword = "$6$q5XmQWicUuay$u5S29deftinjHk2EVQ/bcgWOCjX7GSOD9IE4EiVcc1KhJjpL/uIm0L6Jp1ENROrlEtnl/1kOO5NOCr477aCS51";
    publicSshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXnuZRQxLK5mtR74RfVXh2q8fGlR9p7jGHXYBj5FqTALUs61xC0aKvJj2HmTfTA9Hr3I7GptaXsky66YZmxIGqXtxjSDFksDEIUlKloS2IQYfR2I3NdVnFj4JUb5QcK4Q7SZUn23ftkY5zGGR1Y9btyW5APJn5FO8lT0hzr/8frorS8kzreUZhiLWPw2ij5AgBdGBbEtk05FBNZRDsjy4i4JDZ12oieb2oEaKTdXMmnyVfDtQesC3EvPL1QiGAf4a+Kx+VkCiW46jpgXSjRDoTVECf6nTqmoP7k+I7+z3TJPSxO+y2+w6mIkbsuYmoy8apHE05vvwQYH3KTxmrHFIx raphael@lullis.net";
  };
in
{
  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = with pkgs; [
    dig
    vim
    e2fsprogs
    btrfs-progs
    hdparm
    lsof
    killall
    file
    wget
    curl
  ];

  users.users.raphael = {
    isNormalUser = true;
    hashedPassword = credentials.hashedPassword;
    openssh.authorizedKeys.keys = [
      credentials.publicSshKey
    ];
  };

  # time.timeZone = "Europe/Berlin";
  networking.domain = "home.lullis.net";
  networking.nameservers = [ "1.1.1.1" "4.2.2.1" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
  };

  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
