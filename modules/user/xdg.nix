{...}: {
  flake = {
    nixosModules.xdg = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports =
        []
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            users.${username} = {
              directories = [
                ".config"
                ".local/share"
                ".local/state"
              ];
            };
          };
        };
      home-manager.users.${username} = {config, ...}: let
        homeBase =
          if impermanence
          then "${config.home.homeDirectory}/persist"
          else config.home.homeDirectory;
      in {
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
            desktop = null;
            download = "${homeBase}/Downloads";
            documents = "${homeBase}/Documents";
            pictures = "${homeBase}/Pictures";
            music = null;
            publicShare = null;
            templates = "${homeBase}/Templates";
            videos = "${homeBase}/Videos";
            projects = "${homeBase}/Projects";
            extraConfig = {
              XDG_GAMES_DIR = "${homeBase}/Games";
            };
          };
        };
      };
    };
  };
}
