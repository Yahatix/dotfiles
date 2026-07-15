{
  pkgs,
  unstable,
  lib,
  ...
}:

{
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  # Home Manager needs a bit of information about you and the paths it should
  # manage
  home.username = "tim";
  home.homeDirectory = "/home/tim";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.
  fonts.fontconfig.enable = true;

  #The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    unstable.zed-editor-fhs
    gitkraken
    nil
    nixd
    nixfmt
    mpv
    filezilla
    rustdesk-flutter
    resources
    devenv
    ctop
    nh
    zellij
    lazygit
    gitui
    godot
    godot-mcp

    bottles
    appimage-run
    flatpak

    firefox

    unstable.heroic

    uutils-coreutils
    #screen
    #rustscan
    #dig
    #localsend

    discord
    teamspeak6-client
    simple-scan
    orca-slicer
    onlyoffice-desktopeditors
    freecad
    gimp3
    inkscape
    unstable.beeper
    unstable.thunderbird-latest
    spotify
    cameractrls-gtk4
    oculante

    gramps

    mysql-workbench
    mariadb

    noto-fonts-cjk-serif

  ];

  home.sessionVariables = {
    FLAKE = "/home/tim/.dotfiles";
    NH_FLAKE = "/home/tim/.dotfiles";
    COSMIC_DATA_CONTROL_ENABLED = "1";
  };

  services = {
    ssh-agent = {
      enable = true;
    };
  };

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ".." = "cd ..";
        ls = "eza -li";
        ll = "eza -lia";
        vim = "nvim";

        dcu = "docker compose up -d";
        dcd = "docker compose down";
        dcl = "docker compose logs -f";
        dcr = "docker compose restart";
        dce = "docker compose exec";
      };
      bashrcExtra = ''
        # SSH Agent
        export SSH_AUTH_SOCK="/run/user/1000/ssh-agent"

        # pnpm
        export PNPM_HOME="/home/tim/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        # pnpm end

        eval "$(devenv hook bash)"
      '';
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
    };

    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };

    atuin = {
      enable = true;
      enableBashIntegration = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
