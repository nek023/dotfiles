{ lib, username, ... }:

let
  privateDir = builtins.getEnv "DOTFILES_PRIVATE_DIR";
  hasPrivate = privateDir != "" && builtins.pathExists "${privateDir}/modules/darwin.nix";
in
{
  imports = [
    ./system-defaults.nix
  ] ++ lib.optionals hasPrivate [
    "${privateDir}/modules/darwin.nix"
  ];

  system.primaryUser = username;

  nix.enable = false; # nix.conf is owned by Determinate Nix

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.activationScripts.postActivation.text = ''
    /usr/bin/sudo -u ${username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  system.stateVersion = 6; # do not raise
}
