# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, inputs, ... }: {
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "ocm285";

  networking.networkmanager.enable = true;

  networking.hosts = {
    #"127.0.0.1" = [ "outletcity-dev.com" "www.outletcity-dev.com" ];
    "87.106.162.23" = [  "outletcity-dev.com" "www.outletcity-dev.com" ];
    #  "192.168.178.1" = [ "fritz.box" ];
  };
  networking.firewall.allowedTCPPorts = [ 9002 5173 ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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
    gnome-terminal
  ];
  environment.sessionVariables = {
    FLAKE = "/home/tim/.dotfiles";
    NH_FLAKE = "/home/tim/.dotfiles";
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  services.printing.enable = true;
  services.ipp-usb.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };


  services.pulseaudio.enable = false;
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
  };

  virtualisation.docker.enable = true;

  programs.bash.blesh.enable = true;
  programs.nm-applet.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.nix-software-center.packages.${system}.nix-software-center
    nixpkgs-fmt
    unzip
    zip
    tldr
    unstable.wget
    unstable.neovim
    unstable.duf
    unstable.htop
    unstable.git
    unstable.ps
    unstable.gettext
    brscan5
    spice-gtk
    usbredir
    gparted
    cups-brother-mfcl2800dw
  ];

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # hardware.wooting.enable = true;
  services.udev.packages = [ unstable.wooting-udev-rules ];

  system.stateVersion = "24.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_full;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [ virtiofsd ];
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

  hardware.graphics = {
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
