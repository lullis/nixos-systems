{ pkgs, ... }: {
  services.logind.lidSwitch = "ignore";
}
