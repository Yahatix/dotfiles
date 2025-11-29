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

  # The home.packages option allows you to install Nix packages into your
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
    rustdesk

    unstable.bottles
    appimage-run
    flatpak

    unstable.google-chrome
    firefox

    unstable.heroic
    #modrinth-app
    (
      let
        pname = "modrinth";
        version = "0.10.20";
        src = pkgs.fetchurl {
          url = "https://launcher-files.modrinth.com/versions/${version}/linux/Modrinth%20App_${version}_amd64.AppImage";
          hash = "sha256-2Dwbn+bKQPpvK1N/2yMZWxbcqA1S6IDaO0sljLytMxM=";
        };
        appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
      in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        pkgs = pkgs;
        extraInstallCommands = ''
          install -m 444 -D ${appimageContents}/Modrinth\ App.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/Modrinth\ App.desktop \
            --replace 'Exec=ModrinthApp' 'Exec=${pname}'
          cp -r ${appimageContents}/usr/share/icons $out/share
        '';
      }
    )

    unstable.uutils-coreutils
    nvtopPackages.full
    screen
    neohtop
    rustscan
    dig
    localsend

    discord
    simple-scan
    orca-slicer
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
    nextcloud-client
    (
      let
        pname = "freeshow";
        version = "1.4.8";
        src = pkgs.fetchurl {
          url = "https://github.com/ChurchApps/FreeShow/releases/download/v${version}/FreeShow-${version}-x86_64.AppImage";
          hash = "sha256-SopfSQY4LfllOu9rd1xYFW0nDCYEUz8DNWT9P5JBeD4=";
        };
        appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
      in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        pkgs = pkgs;
        extraInstallCommands = ''
          install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          cp -r ${appimageContents}/usr/share/icons $out/share
        '';
      }
    )

    gramps

    # Work
    unstable.slack
    mysql-workbench
    mariadb
    jetbrains.idea-ultimate

    unstable.ctop
    unstable.nh
    noto-fonts-cjk-serif
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
    # ".config/husky/init.sh".text = ''
    #   eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    # '';
  };

  home.sessionVariables = {
    FLAKE = "/home/tim/.dotfiles";
    NH_FLAKE = "/home/tim/.dotfiles";
    COSMIC_DATA_CONTROL_ENABLED = "1";
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
