_: {
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };
                  "@var" = {
                    mountpoint = "/var";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "space_cache=v2"
                      "discard=async"
                    ];
                  };
                };
              };
            };
          };
        };
      };

      ssd = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib";
                mountOptions = [
                  "noatime"
                  "errors=remount-ro"
                ];
              };
            };
          };
        };
      };

      hdd = {
        type = "disk";
        device = "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            storage = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                extraArgs = [
                  "-d"
                  "su=64k,sw=1"
                  "-l"
                  "size=256m,lazy-count=1"
                ];
                mountpoint = "/mnt/storage";
                mountOptions = [
                  "noatime"
                  "largeio"
                  "inode64"
                  "noquota"
                  "allocsize=64m"
                ];
              };
            };
          };
        };
      };
    };
  };
}
