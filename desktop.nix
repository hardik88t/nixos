{ config, pkgs, ... }:

{
  # Desktop environment configuration

  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    
    # Display manager
    displayManager = {
      gdm.enable = true;
      # Uncomment for auto-login
      # autoLogin = {
      #   enable = true;
      #   user = "hemis";
      # };
    };

    # Desktop environment - GNOME (default)
    desktopManager.gnome.enable = true;
    
    # Alternative desktop environments (uncomment to use)
    # desktopManager.plasma5.enable = true;  # KDE Plasma
    # desktopManager.xfce.enable = true;     # XFCE
    # desktopManager.mate.enable = true;     # MATE
    # desktopManager.cinnamon.enable = true; # Cinnamon
    
    # Window managers (uncomment to use instead of DE)
    # windowManager.i3.enable = true;
    # windowManager.awesome.enable = true;
    # windowManager.xmonad.enable = true;
    # windowManager.bspwm.enable = true;

    # Configure keymap
    xkb = {
      layout = "us";
      variant = "";
    };

    # Enable touchpad support
    libinput.enable = true;
  };

  # Wayland support (uncomment for Wayland session)
  # services.xserver.displayManager.gdm.wayland = true;

  # Audio configuration
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Printing support
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      splix
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];
  };

  # Scanner support
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };

  # Desktop applications
  environment.systemPackages = with pkgs; [
    # File managers
    nautilus
    thunar
    ranger
    nnn
    lf

    # Terminals
    gnome.gnome-terminal
    alacritty
    kitty
    wezterm
    terminator

    # Text editors
    gedit
    kate
    mousepad
    sublime4
    atom

    # Web browsers
    firefox
    chromium
    brave
    microsoft-edge

    # Media players
    vlc
    mpv
    celluloid
    rhythmbox
    spotify
    audacious

    # Image viewers and editors
    eog
    feh
    sxiv
    gimp
    inkscape
    krita
    darktable
    rawtherapee

    # Office suites
    libreoffice
    onlyoffice-bin
    wpsoffice

    # Communication
    discord
    slack
    telegram-desktop
    signal-desktop
    thunderbird
    evolution

    # Development tools (GUI)
    vscode
    sublime4
    jetbrains.idea-ultimate
    android-studio
    dbeaver

    # System utilities
    gnome.gnome-system-monitor
    htop
    btop
    baobab
    gparted
    bleachbit
    stacer

    # Archive managers
    file-roller
    ark
    xarchiver
    p7zip
    unrar

    # Screenshot and screen recording
    gnome.gnome-screenshot
    flameshot
    spectacle
    peek
    obs-studio
    simplescreenrecorder

    # PDF viewers
    evince
    okular
    zathura
    mupdf

    # Video editors
    kdenlive
    openshot-qt
    pitivi
    davinci-resolve

    # 3D and CAD
    blender
    freecad
    openscad

    # Games
    steam
    lutris
    heroic
    bottles
    wine
    winetricks

    # Virtualization
    virt-manager
    virtualbox
    vmware-workstation

    # Network tools (GUI)
    wireshark
    networkmanager-applet
    nm-tray

    # Themes and customization
    gnome.gnome-tweaks
    dconf-editor
    lxappearance
    qt5ct
    
    # Icon themes
    papirus-icon-theme
    numix-icon-theme
    tela-icon-theme
    
    # GTK themes
    arc-theme
    numix-gtk-theme
    dracula-theme
  ];

  # GNOME-specific configuration
  services.gnome = {
    gnome-keyring.enable = true;
    sushi.enable = true; # File previewer
    tracker.enable = true; # File indexing
    tracker-miners.enable = true;
  };

  # Exclude some GNOME applications
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-music
    epiphany # GNOME web browser
    geary # Email client
    totem # Video player
  ]) ++ (with pkgs.gnome; [
    cheese # Webcam tool
    gnome-terminal
    tali # Poker game
    iagno # Go game
    hitori # Sudoku game
    atomix # Puzzle game
  ]);

  # XDG portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Fonts for better desktop experience
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    material-icons
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
  ];

  # Enable location services
  services.geoclue2.enable = true;

  # Enable automatic screen brightness
  services.clight = {
    enable = true;
    settings = {
      verbose = true;
      backlight.disabled = false;
      dpms.timeouts = [ 900 1200 ];
      screen.disabled = false;
    };
  };

  # Enable redshift for eye strain reduction
  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "0.8";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  # Gaming optimizations
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable Flatpak for additional applications
  services.flatpak.enable = true;
}
