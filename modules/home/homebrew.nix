{ config, lib, pkgs, ... }:

let
  cfg = config.my.homebrew;

  brewPath =
    if pkgs.stdenv.isDarwin then
      "/opt/homebrew/bin/brew"
    else
      "/home/linuxbrew/.linuxbrew/bin/brew";

  lines =
    map (t: ''tap "${t}"'') cfg.taps
    ++ map (b: ''brew "${b}"'') cfg.brews
    ++ lib.optionals pkgs.stdenv.isDarwin (
      map (c: ''cask "${c}"'') cfg.casks
      ++ lib.mapAttrsToList (name: id: ''mas "${name}", id: ${toString id}'') cfg.masApps
    )
    ++ map (v: ''vscode "${v}"'') cfg.vscode;

  brewfile = pkgs.writeText "Brewfile" (lib.concatStringsSep "\n" lines + "\n");

  masPackages = lib.optionals (pkgs.stdenv.isDarwin && cfg.masApps != { }) [ pkgs.mas ];

  vscodeBin = lib.optionals (pkgs.stdenv.isDarwin && cfg.vscode != [ ]) [
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  ];

  httpProxy = builtins.getEnv "http_proxy";
  proxyEnv = lib.optionalString (httpProxy != "")
    ''http_proxy="${httpProxy}" https_proxy="${httpProxy}" '';

  activationPath = lib.concatStringsSep ":" (
    map (p: "${p}/bin") masPackages ++ vscodeBin
  );
in
{
  options.my.homebrew = {
    taps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Taps to add.";
    };

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Formulae that nixpkgs does not carry, or whose nixpkgs build is unusable.";
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "GUI applications and fonts. Only applied on macOS.";
    };

    masApps = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = { };
      example = { "Xcode" = 497799835; };
      description = "App Store applications, keyed by name with their id.";
    };

    vscode = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "VSCode extensions.";
    };
  };

  config = {
    home.packages = masPackages;

    home.activation.homebrew = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x "${brewPath}" ]; then
        PATH="${lib.optionalString (activationPath != "") "${activationPath}:"}$PATH" \
        ${proxyEnv}HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_REQUIRE_TAP_TRUST=1 \
          "${brewPath}" bundle --file=${brewfile} --no-upgrade
      else
        echo "homebrew not found at ${brewPath}; skipping" >&2
      fi
    '';
  };
}
