#!/usr/bin/env -S nix shell nixpkgs#keyutils nixpkgs#bash --command bash

sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sdb -- mklabel gpt

sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 1 esp on

sudo parted /dev/sda -- mkpart primary 512MB -20GB
sudo parted /dev/sdb -- mkpart primary 1MB 100%

sudo parted /dev/sda -- mkpart swap linux-swap -20GB 100%

sudo mkfs.fat -F 32 -n boot /dev/sda1

sudo keyctl link @u @s

sudo bcachefs format --encrypt \
  --compression=lz4 \
  --background_compression=zstd \
  --label=ssd.ssd1 /dev/sda2 \
  --label=hdd.hdd1 /dev/sdb1 \
  --fs_label nixos \
  --foreground_target=ssd \
  --promote_target=ssd \
  --background_target=hdd

sudo bcachefs unlock /dev/sda2
sudo bcachefs unlock /dev/sdb1

sudo mount.bcachefs /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

sudo swapon /dev/sda3

sudo nixos-generate-config --root /mnt
