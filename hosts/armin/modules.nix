{...}: {
  imports = [../common/desktop-modules.nix];

  custom = {
    stylix = {
      image = {
        width = "2256";
        height = "1504";
      };
    };
  };
}
