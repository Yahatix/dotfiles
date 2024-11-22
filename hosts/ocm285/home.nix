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
  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    unstable.vscode
    unstable.slack
    unstable.spotify
    unstable.gitkraken
    unstable.beeper
    unstable.thunderbird-latest
    gnome.simple-scan
    flameshot
    bambu-studio
    unstable.google-chrome
    unstable.onlyoffice-desktopeditors

    unstable.mysql-workbench
    unstable.ctop
    unstable.mariadb

    unstable.nh

    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    monaspace
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
    FLAKE = "/home/tim/.dotfiles";
  };



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    package = unstable.alacritty;
  };

  programs.bash = {
    enable = true;
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
    package = unstable.zellij;
  };

  programs.mise = {
    enable = true;
    package = unstable.mise;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = true;
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;
    package = unstable.vscode;
    keybindings = [
      {
        key = "alt+[Semicolon]";
        command = "editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "alt+[Quote]";
        command = "editor.action.blockComment";
        when = "editorTextFocus && !editorReadonly";
      }
    ];

    extensions = [
      unstable.vscode-extensions.svelte.svelte-vscode
      unstable.vscode-extensions.dbaeumer.vscode-eslint
      unstable.vscode-extensions.github.copilot
      unstable.vscode-extensions.github.copilot-chat
      unstable.vscode-extensions.esbenp.prettier-vscode
      unstable.vscode-extensions.bradlc.vscode-tailwindcss
      unstable.vscode-extensions.vue.volar
      unstable.vscode-extensions.eamodio.gitlens
      unstable.vscode-extensions.bbenoist.nix
      unstable.vscode-extensions.jnoortheen.nix-ide
      unstable.vscode-extensions.christian-kohler.path-intellisense
    ];

    userSettings = {
      "editor.formatOnSave" = true;

      "editor.fontFamily" = "Monaspace Radon Var, Fira Code, Monaco, monospace";
      "editor.fontSize" = 16;
      "terminal.integrated.fontFamily" = "Monaspace Radon Var, Fira Code, Monaco, monospace";
      "editor.fontLigatures" = "'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga'";

      "[vue]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "svelte.enable-ts-plugin" = true;
      "[svelte]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
    };
  };
}
