{ config, pkgs, unstable, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tim";
  home.homeDirectory = "/home/tim";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    unstable.vscode
    unstable.slack
    unstable.spotify
    unstable.alacritty
    unstable.mise
    unstable.gitkraken
    unstable.beeper
    unstable.thunderbird-latest
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
    unstable.nh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    FLAKE = "/home/tim/my-flake";
    SHELL = "${pkgs.bash}/bin/bash";
  };



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    shellAliases = {
      vim = "nvim";
      plat = "cd /srv/hybris/bin/platform";
      fe = "cd /srv/hybris/bin/custom/ocm/ocmstorefront/web/webroot/WEB-INF/_ui-src";
      dcu = "docker compose up -d";
      dcd = "docker compose down";
      dcr = "docker compose restart";
      hybris = "zellij --layout /srv/hybris/layout.kdl";
      pms = "zellij --layout ~/projects/ProductManagementSuite/layout.kdl";
    };
    bashrcExtra = ''
      # pnpm
      export PNPM_HOME="/home/tim/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
      # pnpm end
    '';
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };
}
