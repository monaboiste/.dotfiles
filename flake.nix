{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-homebrew,
      home-manager,
      nixpkgs,
    }:
    let
      vars = rec {
        user = "mszumna";
        hostPlatform = "aarch64-darwin";
        homeDirectory = "/Users/${user}";
        dotfiles = "${homeDirectory}/.dotfiles";
      };
    in
    {
      darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit vars; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit vars; };
            home-manager.users.${vars.user} = import ./home.nix;
          }
        ];
      };
    };
}
