{ config, pkgs, lib, ... }:

let
  sources = import ./lon.nix;
  lanzaboote = import sources.lanzaboote {
    inherit pkgs;
  };
in
{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = [
    pkgs.sbctl
  ];

  # Lanzaboote replaces the ordinary systemd-boot installer.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  system.build.installBootLoader = lib.mkForce (
    pkgs.writeShellScript "install-lanzaboote-with-shell" ''
      set -euo pipefail

      "${config.boot.loader.external.installHook}" "$@"

      shell_dir="${config.boot.loader.efi.efiSysMountPoint}/EFI/edk2-uefi-shell"
      ${pkgs.coreutils}/bin/mkdir -p "$shell_dir"

      shell_tmp=$(${pkgs.coreutils}/bin/mktemp "$shell_dir/shell.XXXXXX")
      trap '${pkgs.coreutils}/bin/rm -f "$shell_tmp"' EXIT

      ${pkgs.coreutils}/bin/cp \
        "${pkgs.edk2-uefi-shell}/shell.efi" "$shell_tmp"

      ${pkgs.sbctl}/bin/sbctl sign "$shell_tmp"

      ${pkgs.coreutils}/bin/mv -f "$shell_tmp" "$shell_dir/shell.efi"
    ''
  );
}
