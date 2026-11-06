# Disk layout, applied by nixos-anywhere on install. GRUB on UEFI, matching
# the `host.boot` defaults.
{
  disko.devices.disk.main = {
    type = "disk";
    # Placeholder: check with `lsblk` on the machine, prefer /dev/disk/by-id/…
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
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
