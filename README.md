# nix-configuration
NixOS Configuration

installation?
```
sudo nix-shell -p git nixVersions.stable

nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#git nixpkgs#nixVersions.stable

# поправиnm хардваре конфиг на текущий конфиг созданный системой

git add .

nix --extra-experimental-features 'nix-command flakes' flake show

nixos-rebuild switch --flake .#nixos --use-remote-sudo
```
