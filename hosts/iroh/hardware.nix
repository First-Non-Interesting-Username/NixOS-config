{
  pkgs,
  inputs,
  username,
  lib,
  ...
}: {
  boot = {
    initrd = {
      systemd = {
        enable = true;
        services.rollback = {
          description = "Wipe root subvolume on boot";
          wantedBy = ["initrd.target"];
          after = ["dev-disk-by\\x2dpartlabel-disk\\x2droot\\x2droot.device"];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "rollback" ''
              mkdir /btrfs_tmp
              mount -t btrfs -o subvol=/ /dev/disk/by-partlabel/disk-root-root /btrfs_tmp
              # Delete nested subvolumes first (if any)
              btrfs subvolume list -o /btrfs_tmp/@ 2>/dev/null | cut -f9 -d' ' | while read subvol; do
                btrfs subvolume delete "/btrfs_tmp/$subvol"
              done
              btrfs subvolume delete /btrfs_tmp/@
              btrfs subvolume create /btrfs_tmp/@
              umount /btrfs_tmp
            '';
          };
        };
      };
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "nvme"
      ];
    };
    supportedFilesystems = [
      "btrfs"
      "xfs"
    ];
  };

  hardware = {
    facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
      reportPath = ./facter.json;
    };
    cpu.intel.updateMicrocode = true;
    usbStorage.manageShutdown = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/storage 0755 ${username} users -"
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/"];
      interval = "monthly";
    };
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    '';
  };

  system.stateVersion = "26.11";

  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  home-manager.users.${username} = _: {
    home.stateVersion = "26.11";
  };
}
