{ homeDirectory }:
let
  # Gruvbox theme
  gruvboxTheme = {
    dark = {
      name = "Gruvbox Emphasis Red Dark";
      primary = "#fb4934";
      primaryText = "#1d2021";
      primaryContainer = "#cc241d";
      secondary = "#d3869b";
      surface = "#1d2021";
      surfaceText = "#ebdbb2";
      surfaceVariant = "#282828";
      surfaceVariantText = "#d5c4a1";
      surfaceTint = "#fb4934";
      background = "#1d2021";
      backgroundText = "#ebdbb2";
      outline = "#928374";
      surfaceContainer = "#282828";
      surfaceContainerHigh = "#32302f";
      surfaceContainerHighest = "#3c3836";
      error = "#fb4934";
      warning = "#fabd2f";
      info = "#83a598";
      matugen_type = "scheme-warm";
    };
    light = {
      name = "Gruvbox Emphasis Red Light";
      primary = "#cc241d";
      primaryText = "#fbf1c7";
      primaryContainer = "#fb4934";
      secondary = "#b16286";
      surface = "#fbf1c7";
      surfaceText = "#3c3836";
      surfaceVariant = "#f2e5bc";
      surfaceVariantText = "#504945";
      surfaceTint = "#cc241d";
      background = "#f9f5d7";
      backgroundText = "#3c3836";
      outline = "#928374";
      surfaceContainer = "#f2e5bc";
      surfaceContainerHigh = "#ebdbb2";
      surfaceContainerHighest = "#d5c4a1";
      error = "#cc241d";
      warning = "#d79921";
      info = "#458588";
      matugen_type = "scheme-warm";
    };
  };

  # DMS settings
  dmsSettings = {
    currentThemeName = "Gruvbox Dark Red";
    customThemeFile = "${homeDirectory}/.config/DankMaterialShell/gruvbox-theme.json";
    matugenScheme = "scheme-tonal-spot";
    runUserMatugenTemplates = false;
    dankBarTransparency = 0;
    dankBarWidgetTransparency = 1;
    popupTransparency = 1;
    dockTransparency = 1;
    use24HourClock = true;
    useFahrenheit = false;
    nightModeEnabled = false;
    weatherLocation = "Stuttgart, Germany";
    weatherCoordinates = "48.7758,9.1829";
    useAutoLocation = true;
    weatherEnabled = true;
    showLauncherButton = true;
    showWorkspaceSwitcher = true;
    showFocusedWindow = true;
    showWeather = true;
    showMusic = true;
    showClipboard = true;
    showCpuUsage = true;
    showMemUsage = true;
    showCpuTemp = true;
    showGpuTemp = true;
    selectedGpuIndex = 0;
    enabledGpuPciIds = [ ];
    showSystemTray = true;
    showClock = true;
    showNotificationButton = true;
    showBattery = true;
    showControlCenterButton = true;
    controlCenterShowNetworkIcon = true;
    controlCenterShowBluetoothIcon = true;
    controlCenterShowAudioIcon = true;
    controlCenterWidgets = [
      {
        id = "volumeSlider";
        enabled = true;
        width = 50;
      }
      {
        id = "brightnessSlider";
        enabled = true;
        width = 50;
      }
      {
        id = "wifi";
        enabled = true;
        width = 50;
      }
      {
        id = "bluetooth";
        enabled = true;
        width = 50;
      }
      {
        id = "audioOutput";
        enabled = true;
        width = 50;
      }
      {
        id = "audioInput";
        enabled = true;
        width = 50;
      }
    ];
    showWorkspaceIndex = false;
    showWorkspacePadding = false;
    showWorkspaceApps = false;
    maxWorkspaceIcons = 3;
    workspacesPerMonitor = true;
    workspaceNameIcons = { };
    waveProgressEnabled = true;
    clockCompactMode = false;
    focusedWindowCompactMode = false;
    runningAppsCompactMode = true;
    runningAppsCurrentWorkspace = false;
    clockDateFormat = "ddd MMM d";
    lockDateFormat = "";
    mediaSize = 1;
    dankBarLeftWidgets = [
      {
        id = "workspaceSwitcher";
        enabled = true;
      }
      {
        id = "focusedWindow";
        enabled = true;
      }
    ];
    dankBarCenterWidgets = [
      "music"
      "clock"
      "weather"
    ];
    dankBarRightWidgets = [
      {
        id = "privacyIndicator";
        enabled = true;
      }
      {
        id = "colorPicker";
        enabled = true;
      }
      {
        id = "diskUsage";
        enabled = true;
      }
      {
        id = "battery";
        enabled = true;
      }
      {
        id = "controlCenterButton";
        enabled = true;
      }
      {
        id = "notificationButton";
        enabled = true;
      }
    ];
    appLauncherViewMode = "list";
    spotlightModalViewMode = "list";
    sortAppsAlphabetically = false;
    networkPreference = "auto";
    iconTheme = "System Default";
    launcherLogoMode = "compositor";
    launcherLogoCustomPath = "";
    launcherLogoColorOverride = "#df4633";
    launcherLogoColorInvertOnMode = false;
    launcherLogoBrightness = 0.5;
    launcherLogoContrast = 1;
    launcherLogoSizeOffset = 0;
    fontFamily = "JetBrainsMonoNL Nerd Font";
    monoFontFamily = "JetBrainsMonoNL Nerd Font";
    fontWeight = 400;
    fontScale = 1;
    dankBarFontScale = 0.85;
    notepadUseMonospace = true;
    notepadFontFamily = "";
    notepadFontSize = 14;
    notepadShowLineNumbers = false;
    notepadTransparencyOverride = -1;
    notepadLastCustomTransparency = 0.7;
    soundsEnabled = true;
    useSystemSoundTheme = false;
    soundNewNotification = true;
    soundVolumeChanged = true;
    soundPluggedIn = true;
    gtkThemingEnabled = false;
    qtThemingEnabled = false;
    showDock = false;
    dockAutoHide = false;
    dockGroupByApp = false;
    dockOpenOnOverview = false;
    dockPosition = 1;
    dockSpacing = 4;
    dockBottomGap = 0;
    cornerRadius = 12;
    notificationOverlayEnabled = false;
    dankBarAutoHide = false;
    dankBarOpenOnOverview = false;
    dankBarVisible = true;
    dankBarSpacing = 4;
    dankBarBottomGap = 0;
    dankBarInnerPadding = 4;
    dankBarSquareCorners = false;
    dankBarNoBackground = false;
    dankBarGothCornersEnabled = false;
    dankBarBorderEnabled = false;
    dankBarBorderColor = "surfaceText";
    dankBarBorderOpacity = 1;
    dankBarBorderThickness = 1;
    popupGapsAuto = true;
    popupGapsManual = 4;
    dankBarPosition = 0;
    lockScreenShowPowerActions = true;
    enableFprint = false;
    maxFprintTries = 3;
    hideBrightnessSlider = false;
    widgetBackgroundColor = "s";
    surfaceBase = "s";
    notificationTimeoutLow = 5000;
    notificationTimeoutNormal = 5000;
    notificationTimeoutCritical = 0;
    notificationPopupPosition = 0;
    osdAlwaysShowValue = false;
    powerActionConfirm = true;
    customPowerActionLogout = "";
    customPowerActionSuspend = "";
    customPowerActionHibernate = "";
    customPowerActionReboot = "";
    customPowerActionPowerOff = "";
    updaterUseCustomCommand = false;
    updaterCustomCommand = "";
    updaterTerminalAdditionalParams = "";
    screenPreferences = {
      dock = [ ];
    };
    animationSpeed = 2;
    acMonitorTimeout = 600;
    acLockTimeout = 300;
    acSuspendTimeout = 0;
    acHibernateTimeout = 0;
    batteryMonitorTimeout = 0;
    batteryLockTimeout = 0;
    batterySuspendTimeout = 0;
    batteryHibernateTimeout = 0;
    lockBeforeSuspend = false;
    loginctlLockIntegration = true;
    launchPrefix = "";
    configVersion = 1;
  };
in
{
  inherit gruvboxTheme dmsSettings;
}
