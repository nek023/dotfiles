{
  description = "Dotfiles for macOS and Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }:
    let
      system = builtins.currentSystem;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      username =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          user = builtins.getEnv "USER";
        in
        if sudoUser != "" then
          sudoUser
        else if user != "" && user != "root" then
          user
        else
          throw "Cannot determine the user name. Set USER, or run through sudo.";
    in
    {
      darwinModules.default = ./modules/darwin;
      homeModules.default = ./modules/home;

      # Lets `make switch` run before home-manager is on PATH.
      packages.${system}.home-manager = home-manager.packages.${system}.home-manager;

      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username; };
        modules = [
          ./modules/darwin
          home-manager.darwinModules.home-manager
          {
            users.users.${username}.home = "/Users/${username}";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.users.${username} = ./modules/home;
          }
        ];
      };

      # Linux has no system layer, so home-manager runs standalone there.
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username; };
        modules = [ ./modules/home ];
      };
    };
}
