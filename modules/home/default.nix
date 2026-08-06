{ pkgs, lib, username, ... }:

let
  privateDir = builtins.getEnv "DOTFILES_PRIVATE_DIR";
  hasPrivate = privateDir != "" && builtins.pathExists "${privateDir}/modules/home.nix";
in
{
  imports = [
    ./homebrew.nix
    ./packages.nix
    ./services.nix
    ./zsh.nix
  ] ++ lib.optionals hasPrivate [
    "${privateDir}/modules/home.nix"
  ];

  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  home.stateVersion = "26.05"; # do not raise

  programs.home-manager.enable = true;
}
