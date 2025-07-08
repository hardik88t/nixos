{ config, pkgs, ... }:

{
  # Development environment configuration
  
  # Enable direnv for project-specific environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Development services
  services = {
    # Enable PostgreSQL
    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE hemis WITH LOGIN PASSWORD 'hemis' CREATEDB;
        CREATE DATABASE hemis;
        GRANT ALL PRIVILEGES ON DATABASE hemis TO hemis;
      '';
    };

    # Enable Redis
    redis = {
      servers."" = {
        enable = true;
        port = 6379;
      };
    };

    # Enable MySQL/MariaDB (commented out by default)
    # mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    #   initialScript = pkgs.writeText "mysql-initScript" ''
    #     CREATE DATABASE IF NOT EXISTS hemis;
    #     CREATE USER IF NOT EXISTS 'hemis'@'localhost' IDENTIFIED BY 'hemis';
    #     GRANT ALL PRIVILEGES ON hemis.* TO 'hemis'@'localhost';
    #     FLUSH PRIVILEGES;
    #   '';
    # };
  };

  # Development packages
  environment.systemPackages = with pkgs; [
    # Version control
    git
    git-lfs
    gh
    gitlab-runner
    pre-commit

    # Editors and IDEs
    vscode
    vim
    neovim
    emacs
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.webstorm
    jetbrains.rust-rover

    # Terminal multiplexers
    tmux
    screen
    zellij

    # Shell enhancements
    zsh
    fish
    starship
    oh-my-zsh
    powerlevel10k
    fzf
    ripgrep
    fd
    bat
    exa
    delta
    zoxide
    atuin

    # Language-specific tools
    # Rust
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy

    # Go
    go
    gopls
    golangci-lint
    delve

    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.poetry
    python3Packages.black
    python3Packages.isort
    python3Packages.flake8
    python3Packages.mypy
    python3Packages.pytest
    python3Packages.ipython
    python3Packages.jupyter
    pyright

    # Node.js/JavaScript/TypeScript
    nodejs
    nodePackages.npm
    yarn
    pnpm
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.nodemon
    nodePackages.pm2
    deno
    bun

    # Java
    openjdk17
    maven
    gradle
    jdt-language-server

    # C/C++
    gcc
    clang
    llvm
    gdb
    valgrind
    cmake
    ninja
    pkg-config
    ccls
    clang-tools

    # PHP
    php
    phpPackages.composer
    phpPackages.psalm
    phpPackages.phpstan

    # Ruby
    ruby
    bundler

    # Databases
    postgresql
    mysql80
    sqlite
    redis
    mongodb
    dbeaver

    # Database CLI tools
    pgcli
    mycli
    litecli
    redis-cli

    # API development
    postman
    insomnia
    httpie
    curl
    jq
    yq

    # Container and orchestration
    docker
    docker-compose
    podman
    buildah
    skopeo
    kubectl
    helm
    k9s
    minikube
    kind

    # Cloud tools
    awscli2
    google-cloud-sdk
    azure-cli
    terraform
    terragrunt
    ansible
    vagrant

    # Monitoring and profiling
    htop
    btop
    iotop
    nethogs
    bandwhich
    hyperfine
    tokei
    loc
    cloc

    # Network tools
    nmap
    netcat
    tcpdump
    wireshark
    mtr
    dig
    whois
    traceroute
    iperf3

    # Build tools
    gnumake
    cmake
    ninja
    meson
    bazel
    buck2

    # Documentation
    pandoc
    mdbook
    hugo
    zola

    # Formatters and linters
    nixpkgs-fmt
    alejandra
    shfmt
    shellcheck
    hadolint
    yamllint
    jsonlint
    markdownlint-cli

    # Language servers
    nil # Nix LSP
    sumneko-lua-language-server
    haskell-language-server
    metals # Scala LSP
    kotlin-language-server
    dart
    flutter
  ];

  # Environment variables for development
  environment.variables = {
    # Editor
    EDITOR = "nvim";
    VISUAL = "code";
    
    # Development
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    
    # Node.js
    NODE_OPTIONS = "--max-old-space-size=8192";
    
    # Python
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages";
    
    # Java
    JAVA_HOME = "${pkgs.openjdk17}/lib/openjdk";
  };

  # Shell aliases for development
  environment.shellAliases = {
    # Git shortcuts
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    gb = "git branch";
    gco = "git checkout";
    
    # Docker shortcuts
    d = "docker";
    dc = "docker-compose";
    dps = "docker ps";
    di = "docker images";
    
    # Kubernetes shortcuts
    k = "kubectl";
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    
    # Development shortcuts
    serve = "python -m http.server";
    myip = "curl ifconfig.me";
    ports = "netstat -tulanp";
  };

  # Enable development-related services
  services.lorri.enable = true; # For direnv integration
}
