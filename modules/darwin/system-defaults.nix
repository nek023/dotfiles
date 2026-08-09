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
      showMissionControlGestureEnabled = true;

      # 2 is Mission Control, 4 is Show Desktop. The modifier keys have no
      # option, and macOS reads an absent one as none, which is what we want.
      wvous-tl-corner = 4;
      wvous-tr-corner = 2;
      wvous-bl-corner = 4;
      wvous-br-corner = 2;
    };

    finder = {
      FXDefaultSearchScope = "SCcf"; # current folder, not the whole Mac
      FXPreferredViewStyle = "Nlsv"; # list view
      NewWindowTarget = "Desktop";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Takes a restart to apply.
    hitoolbox.AppleFnUsageType = "Start Dictation";

    menuExtraClock = {
      ShowDate = 1; # always
      ShowSeconds = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerTapGesture = 2; # look up & data detectors
    };

    # macOS 14 started sweeping every window aside on a wallpaper click.
    WindowManager.EnableStandardClickToShowDesktop = false;

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };
}
