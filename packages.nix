{ config, pkgs, ... }:

{
  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    # System utilities
    wget
    curl
    htop
    btop
    tree
    file
    which
    lsof
    psmisc
    procps
    util-linux
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    gnutar
    gzip
    unzip
    zip
    p7zip
    rsync
    rclone

    # Network tools
    nmap
    netcat
    tcpdump
    wireshark
    dig
    whois
    traceroute
    iperf3

    # Development tools
    git
    gh # GitHub CLI
    vim
    neovim
    emacs
    nano
    tmux
    screen
    zsh
    oh-my-zsh
    starship
    fzf
    ripgrep
    fd
    bat
    exa
    delta
    lazygit
    tig

    # Build tools
    gnumake
    cmake
    ninja
    pkg-config
    autoconf
    automake
    libtool
    m4
    patch

    # Compilers and interpreters
    gcc
    clang
    llvm
    rustc
    cargo
    go
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nodejs
    yarn
    pnpm
    deno
    bun

    # Language servers and formatters
    nil # Nix LSP
    nixpkgs-fmt
    alejandra # Nix formatter
    rust-analyzer
    gopls
    nodePackages.typescript-language-server
    nodePackages.prettier
    black
    isort
    flake8

    # Databases
    sqlite
    postgresql
    redis

    # Container tools
    docker
    docker-compose
    podman
    buildah
    skopeo

    # Cloud tools
    awscli2
    google-cloud-sdk
    terraform
    kubectl
    helm
    k9s

    # Monitoring and debugging
    strace
    ltrace
    gdb
    valgrind
    perf-tools
    sysstat
    iotop
    nethogs

    # Archive and compression
    atool
    cabextract
    cpio
    rpm
    dpkg

    # Text processing
    jq
    yq
    xmlstarlet
    pandoc
    texlive.combined.scheme-medium

    # Media tools
    ffmpeg
    imagemagick
    graphicsmagick
    exiftool

    # Security tools
    gnupg
    pass
    age
    sops
    openssl
    nss
    ca-certificates

    # System monitoring
    lm_sensors
    smartmontools
    hdparm
    parted
    gparted
    ncdu
    duf
    dust

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
    liberation_ttf
    dejavu_fonts
    source-code-pro
    source-sans-pro
    source-serif-pro

    # GUI applications
    firefox
    chromium
    alacritty
    kitty
    wezterm
    rofi
    dmenu
    flameshot
    peek
    obs-studio
    audacity
    kdenlive
    blender
    inkscape
    krita
    darktable
    rawtherapee
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Enable zsh with oh-my-zsh
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" ];
      theme = "robbyrussell";
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Enable starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Fonts configuration
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Liberation Serif" ];
        sansSerif = [ "Noto Sans" "Liberation Sans" ];
        monospace = [ "Fira Code" "Liberation Mono" ];
      };
    };
  };

  # Environment variables
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # Shell aliases
  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -la";
    l = "ls -CF";
    ".." = "cd ..";
    "..." = "cd ../..";
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";
    cat = "bat";
    ls = "exa";
    find = "fd";
  };
}
