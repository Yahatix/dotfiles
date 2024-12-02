{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

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
  home.stateVersion = "24.11"; # Please read the comment before changing.

  services.ssh-agent.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    oxker
    nh
  ];

  home.sessionVariables = {
    FlAKE = "/home/tim/.dotfiles";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ".." = "cd ..";
      ls = "eza -li";
      ll = "eza -lia";
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

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zellij = {
    enable = true;
  };

  programs.mise = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
