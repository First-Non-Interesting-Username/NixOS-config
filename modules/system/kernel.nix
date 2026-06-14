{inputs, ...}: {
  flake = {
    nixosModules.kernel-desktop = {pkgs, ...}: {
      nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;

      nix.settings = {
        extra-substituters = ["https://attic.xuyh0120.win/lantian"];
        extra-trusted-public-keys = [
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
      };
    };
  };
}
