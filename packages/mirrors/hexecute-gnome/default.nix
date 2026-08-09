_: {
  perSystem = {inputs', ...}: {
    packages.hexecute-gnome = inputs'.hexecute-gnome.packages.default;
  };
}
