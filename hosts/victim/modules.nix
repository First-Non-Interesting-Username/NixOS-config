{...}: {
  imports = [../common/desktop-modules.nix];

  custom = {
    stylix = {
      image = {
        width = "2560";
        height = "1440";
      };
    };
  };
}
