{
  disko.devices = {
    disk.nvme = {
      device = "/dev/nvme0n";
      type = "disk";
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

          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [
                "-F"
                "-E"
                "lazy_itable_init=1,lazy_journal_init=1"
              ];
            };
          };
        };
      };
    };
  };
}
