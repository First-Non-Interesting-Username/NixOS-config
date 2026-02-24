{...}: {
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = "/dev/vda";
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
                randomEncryption = true;
              };
            };

            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };

      ssd = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "data";
              };
            };
          };
        };
      };

      hdd = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "storage";
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          atime = "off";
          xattr = "sa";
          acltype = "posixacl";
          mountpoint = "none";
        };
        options.ashift = "12";

        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };
          "nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              mountpoint = "legacy";
              atime = "off";
            };
          };
          "var" = {
            type = "zfs_fs";
            mountpoint = "/var";
            options.mountpoint = "legacy";
          };
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };

          "reserved" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              refreservation = "1G";
            };
          };
        };
      };

      data = {
        type = "zpool";
        mountpoint = "/data";
        rootFsOptions = {
          compression = "zstd";
          xattr = "sa";
          acltype = "posixacl";
          atime = "off";
          mountpoint = "none";
        };
        options.ashift = "12";

        datasets = {
          "stacks" = {
            type = "zfs_fs";
            mountpoint = "/data/stacks";
            options.mountpoint = "legacy";
          };

          "volumes" = {
            type = "zfs_fs";
            mountpoint = "/data/volumes";
            options.mountpoint = "legacy";
          };

          "config" = {
            type = "zfs_fs";
            mountpoint = "/data/config";
            options.mountpoint = "legacy";
          };
        };
      };

      storage = {
        type = "zpool";
        mountpoint = "/mnt/storage";
        rootFsOptions = {
          compression = "zstd";
          xattr = "sa";
          acltype = "posixacl";
          atime = "off";
          recordsize = "1M";
          mountpoint = "none";
        };
        options.ashift = "12";

        datasets = {
          "media" = {
            type = "zfs_fs";
            mountpoint = "/mnt/storage/media";
            options.mountpoint = "legacy";
          };

          "backups" = {
            type = "zfs_fs";
            mountpoint = "/mnt/storage/backups";
            options.mountpoint = "legacy";
          };

          "downloads" = {
            type = "zfs_fs";
            mountpoint = "/mnt/storage/downloads";
            options.mountpoint = "legacy";
          };

          "reserved" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              refreservation = "10G";
            };
          };
        };
      };
    };
  };
}
