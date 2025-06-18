{ pkgs, unstable, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
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
  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    unstable.vscode
    unstable.zed-editor

    unstable.gitkraken
    nil
    mission-center
    mpv
    digikam
    wacomtablet
    unstable.opentabletdriver
    filezilla
    rustdesk

    unstable.bottles
    appimage-run
    flatpak
    gnome-software

    unstable.google-chrome
    firefox

    unstable.heroic

    unstable.uutils-coreutils
    nvtopPackages.full
    screen
    unstable.neohtop
    rustscan
    dig
    
    unstable.drawio
    discord
    simple-scan
    naps2
    unstable.orca-slicer
    #bambu-studio
    flameshot
    unstable.onlyoffice-desktopeditors
    freecad
    unstable.gimp3
    unstable.inkscape
    unstable.beeper
    unstable.thunderbird-latest
    unstable.spotify
    cameractrls-gtk4
    unstable.osu-lazer-bin
    oculante

    gramps

    # Work
    unstable.slack
    mysql-workbench
    mariadb
    unstable.ctop
    jetbrains.idea-ultimate

    unstable.nh
  ];

  # font.packages = with pkgs; [
  #   monaspace
  # ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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
    NH_FLAKE = "/home/tim/.dotfiles";
  };


  programs = {
    home-manager.enable = true;

    alacritty = {
      enable = true;
      package = unstable.alacritty;
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
    };

    lazygit.enable = true;
    gitui.enable = true;

    vscode = {
      enable = true;
      package = unstable.vscode;
      # extensions = [
      #   unstable.vscode-extensions.svelte.svelte-vscode
      #   unstable.vscode-extensions.dbaeumer.vscode-eslint
      #   unstable.vscode-extensions.github.copilot
      #   unstable.vscode-extensions.github.copilot-chat
      #   unstable.vscode-extensions.esbenp.prettier-vscode
      #   unstable.vscode-extensions.bradlc.vscode-tailwindcss
      #   unstable.vscode-extensions.vue.volar
      #   unstable.vscode-extensions.eamodio.gitlens
      #   unstable.vscode-extensions.bbenoist.nix
      #   unstable.vscode-extensions.jnoortheen.nix-ide
      #   unstable.vscode-extensions.christian-kohler.path-intellisense
      #   unstable.vscode-extensions.ms-vscode-remote.remote-ssh
      #   unstable.vscode-extensions.fill-labs.dependi
      # ];
    };
  };
}
