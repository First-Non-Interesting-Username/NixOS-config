_: {
  perSystem = {inputs', ...}: {
    packages.hack = inputs'.hack.packages.default;
  };
}
