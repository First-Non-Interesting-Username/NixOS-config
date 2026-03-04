{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.kernel-laptop =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        boot = {
          kernelParams = [
            "amd_pstate=active"
            "nvme.noacpi=1"
          ];
          kernelPackages = pkgs.linuxPackages_zen;
        };
      };
    nixosModules.kernel-desktop =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

        boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;

        nix.settings = {
          extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
          extra-trusted-public-keys = [
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          ];
        };
      };
  };
}
