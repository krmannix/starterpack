{ config, pkgs, lib, ... }:

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
        editor = "vi";
      };
      init = {
        defaultBranch = "main";
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

  # Skills repository setup
  home.activation.cloneSkills = lib.hm.dag.entryAfter ["writeBoundary"] ''
    SKILLS_REPO="$HOME/projects/mentats"
    SKILLS_TARGET="$HOME/.claude/agents"

    # Clone if missing
    if [ ! -d "$SKILLS_REPO" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone \
        git@github.com:krmannix/mentats.git "$SKILLS_REPO" || true
    fi

    # Create agents directory if missing
    $DRY_RUN_CMD mkdir -p "$SKILLS_TARGET"

    # Symlink each skill (if repo exists)
    if [ -d "$SKILLS_REPO/skills" ]; then
      for skill_dir in "$SKILLS_REPO/skills"/*; do
        if [ -d "$skill_dir" ]; then
          skill_name=$(basename "$skill_dir")
          $DRY_RUN_CMD ln -sfn "$skill_dir" "$SKILLS_TARGET/$skill_name"
        fi
      done
    fi
  '';
}
