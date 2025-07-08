{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hemis";
  home.homeDirectory = "/home/hemis";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # User packages
  home.packages = with pkgs; [
    # Terminal utilities
    bat
    exa
    fd
    ripgrep
    fzf
    zoxide
    starship
    
    # Development tools
    lazygit
    delta
    gh
    
    # Media
    spotify
    discord
    
    # Productivity
    obsidian
    notion-app-enhanced
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "hardik88t";
    userEmail = "77385955+hardik88t@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
    delta.enable = true;
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "exa -l";
      la = "exa -la";
      ls = "exa";
      cat = "bat";
      find = "fd";
      grep = "rg";
      cd = "z";
    };
    
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" "rust" "golang" "python" ];
      theme = "robbyrussell";
    };
    
    initExtra = ''
      # Initialize zoxide
      eval "$(zoxide init zsh)"
      
      # Initialize starship
      eval "$(starship init zsh)"
    '';
  };

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      git_branch = {
        symbol = "🌱 ";
      };
      git_status = {
        conflicted = "🏳";
        ahead = "🏎💨";
        behind = "😰";
        diverged = "😵";
        up_to_date = "✓";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "[++\($count\)](green)";
        renamed = "👅";
        deleted = "🗑";
      };
      nodejs = {
        symbol = "⬢ ";
      };
      python = {
        symbol = "🐍 ";
      };
      rust = {
        symbol = "🦀 ";
      };
      golang = {
        symbol = "🐹 ";
      };
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Essential plugins
      vim-sensible
      vim-surround
      vim-commentary
      vim-repeat
      
      # File navigation
      telescope-nvim
      nvim-tree-lua
      
      # Git integration
      vim-fugitive
      gitsigns-nvim
      
      # Language support
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      
      # Snippets
      luasnip
      cmp_luasnip
      
      # UI enhancements
      lualine-nvim
      bufferline-nvim
      nvim-web-devicons
      
      # Theme
      tokyonight-nvim
    ];
    
    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      set tabstop=2
      set shiftwidth=2
      set expandtab
      set smartindent
      set wrap
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      set scrolloff=8
      set signcolumn=yes
      set updatetime=50
      set colorcolumn=80
      
      " Theme
      colorscheme tokyonight
      
      " Key mappings
      let mapleader = " "
      nnoremap <leader>pf <cmd>Telescope find_files<cr>
      nnoremap <leader>ps <cmd>Telescope live_grep<cr>
      nnoremap <leader>pb <cmd>Telescope buffers<cr>
      nnoremap <leader>ph <cmd>Telescope help_tags<cr>
      nnoremap <leader>e <cmd>NvimTreeToggle<cr>
    '';
  };

  # Alacritty terminal configuration
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        size = 12;
      };
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#c0caf5";
        };
      };
    };
  };

  # Firefox configuration
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "https://start.duckduckgo.com";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
      };
    };
  };

  # Direnv for project-specific environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # GPG configuration
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
}
