{
  description = "Hemis's NixOS configuration";

  inputs = {
    # NixOS official package source, using the unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware-specific configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix User Repository for additional packages
    nur.url = "github:nix-community/NUR";

    # Hyprland (modern Wayland compositor)
    hyprland.url = "github:hyprwm/Hyprland";

    # Firefox addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-colors for consistent theming
    nix-colors.url = "github:misterio77/nix-colors";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          nur.overlay
          # Add custom overlays here
        ];
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # Replace 'nixos' with your actual hostname
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Main configuration
            ./configuration.nix
            
            # Hardware-specific configurations (uncomment as needed)
            # nixos-hardware.nixosModules.lenovo-thinkpad-x1-carbon-gen7
            # nixos-hardware.nixosModules.dell-xps-13-9380
            # nixos-hardware.nixosModules.framework-laptop
            
            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.hemis = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "hemis@nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home.nix ];
        };
      };

      # Development shells
      # Available through 'nix develop' or 'nix-shell'
      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
            alejandra
            nil
            git
            gh
          ];
          shellHook = ''
            echo "Welcome to the NixOS configuration development shell!"
            echo "Available commands:"
            echo "  nixos-rebuild switch --flake .#nixos"
            echo "  home-manager switch --flake .#hemis@nixos"
            echo "  nix flake update"
          '';
        };

        # Python development shell
        python = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            python3Packages.pip
            python3Packages.virtualenv
            python3Packages.poetry
          ];
        };

        # Rust development shell
        rust = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer
            rustfmt
            clippy
          ];
        };

        # Node.js development shell
        node = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            nodePackages.npm
            yarn
            pnpm
          ];
        };
      };

      # Custom packages
      packages.${system} = {
        # Add custom packages here
      };

      # Formatter for 'nix fmt'
      formatter.${system} = pkgs.alejandra;

      # NixOS modules
      nixosModules = {
        # Add custom NixOS modules here
      };

      # Home Manager modules
      homeManagerModules = {
        # Add custom Home Manager modules here
      };
    };
}
