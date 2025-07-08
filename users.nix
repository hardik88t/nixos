{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.hemis = {
    isNormalUser = true;
    description = "Hemis";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "audio" 
      "video" 
      "storage" 
      "optical" 
      "scanner" 
      "input" 
      "power" 
      "users" 
      "docker" 
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      # User-specific packages can be added here
      firefox
      thunderbird
      discord
      spotify
      vlc
      gimp
      libreoffice
      vscode
      obsidian
    ];
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Configure sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Enable dconf (required for some GNOME applications)
  programs.dconf.enable = true;

  # Enable GPG agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable Git system-wide
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Enable Steam (for gaming)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable VirtualBox
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "hemis" ];

  # Enable Flatpak
  services.flatpak.enable = true;

  # XDG portal for better desktop integration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
