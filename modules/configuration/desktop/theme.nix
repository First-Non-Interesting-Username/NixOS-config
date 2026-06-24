{inputs, ...}: {
  flake = {
    nixosModules.theme = {
      config,
      pkgs,
      width ? 1920,
      height ? 1080,
      lib,
      impermanence,
      ...
    }: let
      theme = "gruvbox-dark";
      polarity = "dark";
      inherit (config.lib.stylix) colors;

      svgContent = ''
        <svg height="2160" viewBox="0 0 3840 2160" width="3840"
             xmlns="http://www.w3.org/2000/svg">
          <path d="M0 0h3840v2160H0z" fill="#${colors.base00}"/>
          <g fill-rule="evenodd" transform="translate(416.4 267.6) scale(6.578)">
            <path d="m194.168 125.017 32.017 55.46-14.714.138-8.548-14.9-8.608 14.82-7.31-.003-3.745-6.468 12.265-21.09-8.707-15.15z" fill="#${colors.base0C}"/>
            <path d="m205.725 102.173-32.022 55.458-7.476-12.674 8.63-14.852-17.14-.046-3.653-6.332 3.73-6.478 24.396.078 8.769-15.117z" fill="#${colors.base0E}"/>
            <path d="m208.18 146.506 64.04.003-7.238 12.812-17.178-.048 8.53 14.866-3.657 6.33-7.475.008-12.131-21.166-17.474-.036z" fill="#${colors.base0B}"/>
            <path d="m245.453 122.202-32.017-55.46 14.714-.138 8.548 14.9 8.608-14.82 7.31.002 3.745 6.47-12.265 21.088 8.707 15.151z" fill="#${colors.base09}"/>
            <path d="m231.352 100.578-64.038-.003 7.237-12.812 17.178.047-8.53-14.865 3.657-6.33 7.475-.008 12.131 21.166 17.474.035z" fill="#${colors.base08}"/>
            <path d="M233.858 145.039 265.88 89.58l7.476 12.673-8.63 14.853 17.14.045 3.652 6.333-3.73 6.477-24.396-.077L248.624 145z" fill="#${colors.base0A}"/>
          </g>
        </svg>
      '';

      svgFile = pkgs.writeText "wallpaper.svg" svgContent;

      image = pkgs.runCommand "converted-wallpaper.png" {} ''
        ${pkgs.imagemagick}/bin/magick \
          -density 96 \
          ${svgFile} \
          -resize ${toString width}x${toString height}! \
          -flatten \
          $out
      '';
    in {
      imports =
        [
          inputs.stylix.nixosModules.stylix
        ]
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            users.${config.custom.user.name} = {
              directories = [
                ".cache/fontconfig"
              ];
            };
          };
        };

      programs.dconf.enable = true;

      stylix = {
        autoEnable = false;
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
        inherit polarity;
        inherit image;

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };

        icons = {
          enable = true;
          package = pkgs.morewaita-icon-theme;
          dark = "MoreWaita";
          light = "MoreWaita";
        };

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font";
          };
          sansSerif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Sans";
          };
          serif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Serif";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };

      home-manager.users.${config.custom.user.name} = _: {
        qt = {
          enable = true;
          style.name = "breeze";
        };
        gtk.enable = true;

        stylix = {
          autoEnable = true;
          enable = true;
          targets = {
            vscode.colors.enable = false;
            kde.enable = false;
            qt.enable = false;
            floorp.enable = false;
          };
        };
      };
    };
  };
}
