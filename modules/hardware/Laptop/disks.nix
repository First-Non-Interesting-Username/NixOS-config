{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.disks-Laptop = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        inputs.disko.nixosModules.disko
        ./_disko.nix
      ];

      boot = {
        supportedFilesystems = ["btrfs"];
        kernelParams = ["nohibernate"];
      };

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [
          "/nix"
          "/persist"
        ];
      };

      fileSystems = {
        "/" = {
          neededForBoot = true;
        };
        "/nix" = {
          neededForBoot = true;
        };
        "/persist" = {
          neededForBoot = true;
        };
        "/etc" = {
          depends = [
            "/"
            "/persist"
          ];
          neededForBoot = true;
        };
        "/home" = {
          depends = [
            "/"
            "/persist"
          ];
          neededForBoot = true;
        };
        "/var" = {
          depends = [
            "/"
            "/persist"
          ];
          neededForBoot = true;
        };
        "/var/lib" = {
          depends = [
            "/"
            "/persist"
          ];
          neededForBoot = true;
        };
      };
    };
  };
}
