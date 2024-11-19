# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, ... }:

let
  # unstable = import <nixpkgs-unstable> {
  #   config.allowUnfree = true;
  # };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ocm285";

  networking.networkmanager.enable = true;

  networking.hosts = {
    "127.0.0.1" = [ "outletcity-dev.com" "www.outletcity-dev.com" ];
    "192.168.178.1" = [ "fritz.box" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;
  environment.budgie.excludePackages = with pkgs; [
    vlc
    mate.pluma
    mate.atril
    xterm
  ];

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  services.printing.enable = true;
  services.ipp-usb.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;


  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "libvirtd" ];
    packages = with pkgs; [
      unstable.vscode
      unstable.slack
      unstable.spotify
      unstable.alacritty
      unstable.mise
      unstable.gitkraken
      unstable.beeper
      thunderbird
      unstable.atuin
      gnome.simple-scan
      flameshot
      bambu-studio
      unstable.nodejs
      unstable.pnpm
      unstable.google-chrome
      unstable.onlyoffice-desktopeditors

      unstable.mysql-workbench
      unstable.ctop
      unstable.mariadb

      unstable.zellij
    ];
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  virtualisation.docker.enable = true;

  programs.bash.blesh.enable = true;
  services.atuin.enable = true;
  programs.direnv.enable = true;
  programs.nm-applet.enable = true;

  environment.systemPackages = with pkgs; [
    unstable.wget
    unstable.neovim
    unzip
    zip
    unstable.duf
    unstable.htop
    unstable.git
    unstable.ps
    unstable.gettext
    nixpkgs-fmt
  ];

  hardware.wooting.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?
  system.autoUpgrade.enable = true;


  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
  programs.virt-manager.enable = true;

  hardware.opengl = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

}
