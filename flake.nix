{
  description = "Scully's NixOS configuration";

  inputs = {
    nixpkgs.url = 
      "github:NixOS/nixpkgs/a5cc6f2c37bf518436dc8d1c288ccd0c43c2f4c4";
  };

  outputs = { nixpkgs, ...}: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
      ];
    };
  };
}
