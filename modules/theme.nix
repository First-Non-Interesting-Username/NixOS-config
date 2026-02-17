{
  self,
  inputs,
  width,
  height,
  ...
}: {
  flake = {
    homeModules.theme = {
      pkgs,
      lib,
      config,
      width,
      height,
      ...
    }: {
      imports = [
        inputs.stylix.homeModules.stylix
      ];
      stylix = {
        enable = true;
        image = pkgs.runCommand "converted-wallpaper.png" {} ''
          ${pkgs.imagemagick}/bin/magick \
            -density 300 \
            ${./wallpaper/gruvbox-dark-rainbow.svg} \
            -resize ${toString width}x${toString height} \
            $out
        '';
        # I want to automatically create the SVGs

        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
        polarity = "dark";

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };

        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
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
        targets = {
          vscode.colors.enable = false;
        };
      };
    };
  };
}
