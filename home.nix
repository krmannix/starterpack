{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";
  home.username = "kevin";
  home.homeDirectory = "/Users/kevin";

  # Git configuration
  programs.git = {
    enable = true;

    settings = {
      alias = {
        s = "status";
        unstage = "reset HEAD --";
      };
      core = {
        excludesFile = "~/.gitignore";
      };
      http = {
        postBuffer = 524288000;
      };
      pack = {
        windowMemory = "100m";
        packSizeLimit = "100m";
      };
    };
  };

  # Zsh configuration - symlink entire directory
  home.file.".config/zsh" = {
    source = ./dotfiles/zsh;
    recursive = true;
  };

  # .zshenv must live at ~/.zshenv for ZDOTDIR bootstrap
  home.file.".zshenv".source = ./dotfiles/zsh/.zshenv;

  # iTerm2 configuration
  home.file.".config/iterm2" = {
    source = ./dotfiles/iterm2;
    recursive = true;
  };

  # Cursor settings
  home.file."Library/Application Support/Cursor/User/settings.json".source =
    ./dotfiles/cursor/settings.json;
  home.file."Library/Application Support/Cursor/User/keybindings.json".source =
    ./dotfiles/cursor/keybindings.json;

  # Claude configuration
  home.file.".claude/settings.json".source = ./dotfiles/claude/settings.json;
  home.file."CLAUDE.md".source = ./dotfiles/claude/CLAUDE.md;

  # Sync script
  home.file.".local/bin/nix-sync" = {
    source = ./bin/nix-sync;
    executable = true;
  };
}
