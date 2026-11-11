{
  description = "Scully's NixOS configuration";

  inputs = {
    nixpkgs.url = 
      "github:NixOS/nixpkgs/nixos-unstable";

    nixarchy = {
      url = "github:olafkfreund/nixarchy/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixarchy, ...}: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix

        nixarchy.nixosModules.nixarchy
        nixarchy.inputs.home-manager.nixosModules.home-manager
        ./nixarchy-apps.nix

        {
	  environment.systemPackages = [
	    nixarchy.inputs.hyprland.inputs.hyprland-guiutils.packages.x86_64-linux.default
	  ];

          programs.nixarchy = {
            enable = true;
            user = "scully";
            flake = "/home/scully/nixos-config";
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.scully = {
              imports = [
                nixarchy.homeManagerModules.nixarchy
              ];

            programs.nixarchy.enable = true;

            # Nixarchy's currently tested Home Manager baseline.
            home.stateVersion = "25.05";
          };
         };
        }
      ];
    };
  };
}
