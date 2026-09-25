{
  description = "ideapad NixOS configuration";

  inputs = {
    # Stable channel. NOTE: this is independent of system.stateVersion —
    # bump this every release; never bump stateVersion. (25.11 went EOL
    # 2026-06-30 and its branch no longer receives updates.)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Unstable channel — exposed to the system via an overlay as `pkgs.unstable.*`
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager release — must match the nixpkgs release above
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.ideapad = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        # Overlay that adds `pkgs.unstable` everywhere in the system
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = final.stdenv.hostPlatform.system;
                config.allowUnfree = true;
              };
            })
          ];
        }
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
