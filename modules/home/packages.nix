{ pkgs, ... }:

{
  # Everything else lives in the private repository. Only what this repository
  # needs to run belongs here: make link drives stow, and macOS carries the
  # rest (jq, git, curl, make).
  home.packages = with pkgs; [
    stow
  ];
}
