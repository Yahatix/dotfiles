{
  pkgs,
  unstable,
  ...
}:

{
  # imports = [ inputs.kimai-applet.homeManagerModules.default ];

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
  home.stateVersion = "25.11"; # Please read the comment before changing.
  fonts.fontconfig.enable = true;

  #The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    unstable.vscode
    unstable.zed-editor

    unstable.gitkraken
    nil
    nixd
    nixfmt-rfc-style
    mpv
    filezilla
    rustdesk-flutter
    resources

    unstable.bottles
    appimage-run
    flatpak

    firefox

    unstable.heroic

    unstable.uutils-coreutils
    nvtopPackages.full
    screen
    neohtop
    rustscan
    dig
    localsend

    sweethome3d.application
    discord
    teamspeak6-client
    simple-scan
    orca-slicer
    unstable.onlyoffice-desktopeditors
    unstable.freecad
    unstable.gimp3
    unstable.inkscape
    unstable.beeper
    unstable.thunderbird-latest
    unstable.spotify
    cameractrls-gtk4
    unstable.osu-lazer-bin
    oculante
    nextcloud-client

    gramps

    mysql-workbench
    mariadb

    unstable.ctop
    unstable.nh
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
    alacritty = {
      enable = true;
      package = unstable.alacritty;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "gemeinde" = {
          hostname = "112084.test-my-website.de";
          user = "34921f24455u1";
        };
        "*" = {
          identityFile = "~/.ssh/id_privat";
          addKeysToAgent = "yes";
        };
      };
    };

    bash = {
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

        hybris = "zellij --layout /srv/hybris-flake/layout.kdl";
        pms = "zellij --layout ~/projects/pms-flake/pms-layout.kdl";
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

    zellij = {
      enable = true;
      package = unstable.zellij;
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

    lazygit.enable = true;
    gitui.enable = true;

    vscode = {
      enable = true;
      package = unstable.vscode;
    };
  };
}
