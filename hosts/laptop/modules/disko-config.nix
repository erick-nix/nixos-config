# Installation:
# sudo su
# curl -s https://raw.githubusercontent.com/erick-nix/nixos-config/refs/heads/main/hosts/desktop/modules/disko-config.nix -o /tmp/disk-config.nix
# nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix
# git clone https://github.com/erick-nix/nixos-config.git /mnt/etc/nixos
# nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hosts/desktop/hardware-configuration.nix
# nixos-install --flake /mnt/etc/nixos#desktop
# sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/nvme0n1p2
# nixos-enter --root /mnt -c 'passwd erick-nix'

{ ... }:

{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "noatime" "compress=zstd" ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "noatime" "compress=zstd" ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "noatime" "compress=zstd" ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "noatime" "compress=zstd" ];
                    };
                    "@games" = {
                      mountpoint = "/home/erick-nix/Games";
                      mountOptions = [ "noatime" "compress=no" ];
                    };
                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions = [ "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
