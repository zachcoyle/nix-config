#!/usr/bin/env -S nix shell nixpkgs#keyutils nixpkgs#bash --command bash

sudo parted /dev/nvme0n1 -- mklabel gpt

sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/nvme0n1 -- set 1 esp on

sudo parted /dev/nvme0n1 -- mkpart primary 512MB -20GB

sudo parted /dev/nvme0n1 -- mkpart swap linux-swap -20GB 100%

sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1

sudo keyctl link @u @s

sudo bcachefs format --encrypt \
  --compression=lz4 \
  --background_compression=zstd \
  --label=ssd.ssd1 /dev/nvme0n1p2 \
  --fs_label nixos

sudo bcachefs unlock /dev/nvme0n1p2

sudo mount.bcachefs /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

sudo swapon /dev/nvme0n1p3

sudo nixos-generate-config --root /mnt
