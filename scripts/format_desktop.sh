#!/usr/bin/env -S nix shell nixpkgs#keyutils nixpkgs#bash --command bash

sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart root ext4 512MB -20GB
sudo parted /dev/sda -- mkpart swap linux-swap -20GB 100%
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB

sudo keyctl link @u @s

sudo bcachefs format --encrypt \
  --compression=lz4 \
  --background_compression=zstd \
  --label=ssd.ssd1 /dev/sda1 \
  --label=hdd.hdd1 /dev/sdb \
  --fs_label root \
  --foreground_target=ssd \
  --promote_target=ssd \
  --background_target=hdd

sudo bcachefs unlock /dev/sda1
sudo bcachefs unlock /dev/sdb

# sudo mount -t bcachefs /dev/sda1:/dev/sdb /mnt
