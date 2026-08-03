{ ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };

    finder = {
      FXPreferredViewStyle = "Nlsv"; # list view
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    menuExtraClock = {
      ShowDate = 1; # always
      ShowSeconds = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };
}
