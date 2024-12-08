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
  networking.hostName = "strato";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      80
      443
      1080
      3311
      9002
    ];
    
  };

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

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    htop
    tldr
    duf
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINznJOvn67LuupscOE+RITZZKrXifd5+GsniNAZHE+Vl tim@familie-pflaum.de"
  ];
 
  # For vscode remote
  programs.nix-ld.enable = true;

  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINznJOvn67LuupscOE+RITZZKrXifd5+GsniNAZHE+Vl tim@familie-pflaum.de"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIWTcKjtck+B9X9NiBOZ1zmqoNbxCu+t6ddJaJbcA4Rz tim.pflaum@outletcity.com"
    ];
    packages = with pkgs; [
      oxker
      ctop
      nh
      zellij
      atuin
      eza
      direnv
      bash-preexec
      bash-completion
      gitui
    ];
  };
}
