{ modulesPath
, lib
, pkgs
, inputs
, ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  disko.devices.disk.disk1.device = "/dev/vda";

  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.neovim
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINznJOvn67LuupscOE+RITZZKrXifd5+GsniNAZHE+Vl tim@familie-pflaum.de"
  ];

  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" ];
    packages = with pkgs; [
      oxker
      nh
      zellij
      atuin
      eza
      direnv
      bash-preexec
      bash-completion
    ];
  };
}
