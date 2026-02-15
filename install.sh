#!/usr/bin/env bash
set -euo pipefail

if ! command -v nix &> /dev/null; then
    echo "Error: nix command not found. Please install Nix first."
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "Error: No hostname provided"
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME="$1"

echo "Installing NixOS for hostname: $HOSTNAME"
echo "WARNING: This will wipe the target system and ALL DATA WILL BE LOST!"
echo ""
read -p "Are you sure you want to proceed? (y/n): " confirm

case "$confirm" in
  [yY][eE][sS]|[yY]) 
    echo "Proceeding..."
    ;;
  [nN][oO]|[nN])
    echo "Aborting."
    exit 1
    ;;
  *)
    echo "Invalid input. Please enter y or n."
    exit 1
    ;;
esac

echo "Generating hardware config"
sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o ./modules/hardware/${HOSTNAME}/facter.json

git add .

temp=$(mktemp -d)
echo "Created temporary directory: $temp"

mkdir -p "$temp/etc/nixos"
cp -r . "$temp/etc/nixos/"
echo "Copied flake to temporary directory"

echo "Running nixos-anywhere..."
nix shell github:nix-community/nixos-anywhere --command nixos-anywhere \
  --flake ".#${HOSTNAME}" \
  --copy-host-keys \
  --extra-files "$temp" \
  --target-host "root@localhost"

echo "Cleaning up temporary directory..."
rm -rf "$temp"

echo "Installation complete!"