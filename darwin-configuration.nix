{ config, pkgs, ... }:

{
  # Nix configuration
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    optimise.automatic = true;
  };

  # System packages (minimal, most via Homebrew)
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    # CLI tools
    brews = [
      "antidote"
      "awscli"
      "git-filter-repo"
      "go"
      "postgresql@15"
      "pyenv"
      "rbenv"
      "terraform"
      "zoxide"
    ];

    # GUI applications
    casks = [
      "alfred"
      "cursor"
      "docker"
      "firefox"
      "google-chrome"
      "iterm2"
    ];

    # Mac App Store apps (none for now)
    masApps = {};
  };

  # macOS system settings
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };

  # Set system state version
  system.stateVersion = 5;

  # Add users
  system.primaryUser = "kevin";
  users.users.kevin = {
    name = "kevin";
    home = "/Users/kevin";
  };
}
