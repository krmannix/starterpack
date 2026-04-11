{ config, pkgs, username, ... }:

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
      "flyctl"
      "gh"
      "git-filter-repo"
      "go"
      "hugo"
      "postgresql@15"
      "nvm"
      "pyenv"
      "pyenv-virtualenv"
      "rbenv"
      "terraform"
      "uv"
      "zoxide"
    ];

    # GUI applications
    casks = [
      "alfred"
      "claude"
      "codex"
      "cursor"
      "docker-desktop"
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
  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
