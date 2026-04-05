# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  unstable,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
    # Use a newer kernel version
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "nix";
    networkmanager.enable = true;
    firewall.enable = false;
  };

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

  environment.sessionVariables = {
    FLAKE = "/home/tim/.dotfiles";
    NH_FLAKE = "/home/tim/.dotfiles";
  };

  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic = {
      enable = true;
      xwayland.enable = true;
    };
    udev.packages = [
      unstable.wooting-udev-rules
    ];
    xserver.xkb = {
      layout = "de";
      variant = "";
    };
    printing.enable = true;
    ipp-usb.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  console.keyMap = "de";

  security.rtkit.enable = true;

  # Disable GNOME Keyring SSH agent component
  services.gnome.gnome-keyring.enable = false;

  nixpkgs.config.allowUnfree = true;

  users.users.tim = {
    isNormalUser = true;
    description = "tim";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "input"
      "libvirtd"
    ];
  };

  virtualisation = {
    docker = {
      enable = true;
      daemon = {
        settings = {
          userland-proxy = false;
          experimental = true;
          metrics-addr = "0.0.0.0:9323";
          ipv6 = true;
          fixed-cidr-v6 = "fd00::/80";
          default-address-pools = [
            {
              base = "172.16.0.0/16";
              size = 24;
            }
          ];
        };
      };
    };
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_full;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
        # ovmf = {
        #   enable = true;
        #   packages = [
        #     (pkgs.OVMF.override {
        #       secureBoot = true;
        #       tpmSupport = true;
        #     }).fd
        #   ];
        # };
      };
    };
  };
  programs.virt-manager.enable = true;
  programs.bash.blesh.enable = true;
  programs.ssh.startAgent = true;
  programs.gamemode.enable = true;
  programs.steam.enable = true;
  # programs.nm-applet.enable = true;

  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
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
    networkmanagerapplet
    pavucontrol
    openvpn
    networkmanager-openvpn
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;

  hardware = {
    graphics.enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "amdgpu" ];
}
