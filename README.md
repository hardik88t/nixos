# NixOS Configuration

A comprehensive, modular NixOS configuration with development tools, desktop environment, and modern package management using Nix Flakes.

## 🚀 Features

- **Modular Configuration**: Organized into separate modules for easy maintenance
- **Modern Flake-based Setup**: Uses Nix Flakes for reproducible builds
- **Home Manager Integration**: User-specific configurations managed declaratively
- **Development Environment**: Pre-configured tools for multiple programming languages
- **Desktop Environment**: GNOME desktop with customizations and essential applications
- **Security**: GPG, SSH, and secrets management configured
- **Performance**: Optimized settings for daily use

## 📁 Structure

```
├── configuration.nix      # Main NixOS configuration
├── hardware-configuration.nix  # Hardware-specific settings (template)
├── flake.nix             # Flake configuration with inputs/outputs
├── home.nix              # Home Manager user configuration
├── users.nix             # User accounts and system-wide user settings
├── packages.nix          # System packages and utilities
├── development.nix       # Development tools and environments
├── desktop.nix           # Desktop environment and GUI applications
└── README.md             # This file
```

## 🛠️ Installation

### Prerequisites

1. **Fresh NixOS Installation**: Start with a minimal NixOS installation
2. **Enable Flakes**: Ensure experimental features are enabled
3. **Git**: Required for cloning this repository

### Step 1: Clone the Repository

```bash
# Clone to your NixOS configuration directory
sudo git clone https://github.com/hardik88t/nixos.git /etc/nixos
cd /etc/nixos
```

### Step 2: Update Hardware Configuration

```bash
# Generate your hardware configuration
sudo nixos-generate-config --root /mnt --show-hardware-config > hardware-configuration.nix
```

**Important**: Edit `hardware-configuration.nix` and replace the placeholder UUIDs with your actual partition UUIDs:

```bash
# Find your partition UUIDs
sudo blkid

# Edit the hardware configuration
sudo nano hardware-configuration.nix
```

Replace these placeholders:
- `REPLACE-WITH-YOUR-ROOT-UUID` - Your root partition UUID
- `REPLACE-WITH-YOUR-BOOT-UUID` - Your boot partition UUID
- `REPLACE-WITH-YOUR-SWAP-UUID` - Your swap partition UUID (if applicable)

### Step 3: Customize Configuration

1. **Update hostname** in `configuration.nix`:
   ```nix
   networking.hostName = "your-hostname"; # Change from "nixos"
   ```

2. **Update username** in `users.nix` and `home.nix`:
   ```nix
   users.users.your-username = {  # Change from "hemis"
   ```

3. **Update flake hostname** in `flake.nix`:
   ```nix
   nixosConfigurations = {
     your-hostname = nixpkgs.lib.nixosSystem {  # Change from "nixos"
   ```

### Step 4: Apply Configuration

```bash
# Rebuild and switch to the new configuration
sudo nixos-rebuild switch --flake .#your-hostname

# Or for the first time, you might need:
sudo nixos-rebuild switch --flake .#your-hostname --impure
```

## 🏠 Home Manager

This configuration includes Home Manager for user-specific settings.

### Apply Home Manager Configuration

```bash
# Switch to Home Manager configuration
home-manager switch --flake .#your-username@your-hostname
```

## 📦 Package Management

### System Packages

System-wide packages are defined in `packages.nix`. To add a new system package:

1. Edit `packages.nix`
2. Add the package to `environment.systemPackages`
3. Rebuild: `sudo nixos-rebuild switch --flake .#your-hostname`

### User Packages

User-specific packages are defined in `home.nix`. To add a user package:

1. Edit `home.nix`
2. Add the package to `home.packages`
3. Apply: `home-manager switch --flake .#your-username@your-hostname`

### Development Environments

The configuration includes several development shells accessible via `nix develop`:

```bash
# Default development shell
nix develop

# Language-specific shells
nix develop .#python
nix develop .#rust
nix develop .#node
```

## 🔧 Customization

### Desktop Environment

The default desktop environment is GNOME. To switch to a different DE or WM:

1. Edit `desktop.nix`
2. Comment out GNOME configuration
3. Uncomment your preferred environment (KDE, XFCE, i3, etc.)
4. Rebuild the system

### Development Tools

Development tools are configured in `development.nix`. This includes:

- **Languages**: Rust, Go, Python, Node.js, Java, C/C++
- **Databases**: PostgreSQL, Redis, MySQL
- **Containers**: Docker, Podman
- **Cloud Tools**: AWS CLI, kubectl, Terraform
- **Editors**: Neovim, VS Code, JetBrains IDEs

### Themes and Appearance

Customize themes and fonts in:
- `desktop.nix` - System-wide themes and fonts
- `home.nix` - User-specific application themes

## 🚀 Usage

### Common Commands

```bash
# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#your-hostname

# Update Home Manager
home-manager switch --flake .#your-username@your-hostname

# Garbage collection
sudo nix-collect-garbage -d
nix-collect-garbage -d

# Check system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

### Development Workflow

1. **Project Setup**: Use `direnv` for project-specific environments
2. **Database Development**: PostgreSQL and Redis are pre-configured
3. **Container Development**: Docker and Podman ready to use
4. **Version Control**: Git with useful aliases and delta for diffs

## 🔒 Security

- **GPG**: Configured for signing commits and encryption
- **SSH**: Agent configured with GPG integration
- **Firewall**: Enabled with sensible defaults
- **Sudo**: Wheel group configuration with password requirement

## 🎮 Gaming

Gaming support includes:
- **Steam**: Enabled with Remote Play support
- **Lutris**: For non-Steam games
- **Wine**: Windows compatibility layer
- **GameMode**: Performance optimizations

## 📱 Applications

### Included Applications

**Development**:
- VS Code, Neovim, JetBrains IDEs
- Git, GitHub CLI, Docker
- Multiple language toolchains

**Productivity**:
- Firefox, LibreOffice
- Obsidian, Thunderbird
- File managers and utilities

**Media**:
- VLC, Spotify, Discord
- GIMP, Inkscape, Blender
- OBS Studio for streaming

**System**:
- Alacritty terminal
- System monitoring tools
- Archive managers

## 🔄 Updates

### Updating the System

```bash
# Update flake inputs
nix flake update

# Rebuild with new packages
sudo nixos-rebuild switch --flake .#your-hostname

# Update Home Manager
home-manager switch --flake .#your-username@your-hostname
```

### Staying Current

- **NixOS**: Tracks `nixos-unstable` for latest packages
- **Home Manager**: Follows nixpkgs for consistency
- **Flake Inputs**: Update regularly with `nix flake update`

## 🐛 Troubleshooting

### Common Issues

1. **Build Failures**: Check for syntax errors in Nix files
2. **Missing Hardware**: Update `hardware-configuration.nix`
3. **Permission Issues**: Ensure proper file ownership
4. **Flake Errors**: Try `--impure` flag for first build

### Getting Help

- **NixOS Manual**: `nixos-help`
- **Home Manager Manual**: Available online
- **Community**: NixOS Discourse and Reddit

## 📄 License

This configuration is provided as-is for educational and personal use. Feel free to fork and modify for your needs.

## 🤝 Contributing

Feel free to submit issues and pull requests for improvements!
