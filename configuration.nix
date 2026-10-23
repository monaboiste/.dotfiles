{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  users.users.${user} = {
    home = "/Users/${user}";
  };

  system = {
    primaryUser = user;
    stateVersion = 6;
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        KeyRepeat = 2;          # fast key repeat
        InitialKeyRepeat = 15;  # short delay before repeat
        _HIHideMenuBar = true;  # auto-hide the menu bar
        AppleShowAllExtensions = true;
      };
      dock.autohide = true;
      finder.FXPreferredViewStyle = "Nlsv";  # list view by default
      finder.CreateDesktop = false;          # clean desktop
      trackpad.Clicking = true;              # tap to click
    };
  };

  nix-homebrew = {
    enable = true;
    autoMigrate = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    brews = [
      "awscli"
      "bat"
      "can1357/tap/omp"
      "curl"
      "difftastic"
      "eza"
      "fd"
      "fnm"
      "fzf"
      "gh"
      "git"
      "herdr"
      "jq"
      "neovim"
      "pi-coding-agent"
      "python"
      "rich"
      "ripgrep"
      "rtk"
      "rumdl"
      "rust"
      "sevenzip"
      "shfmt"
      "starship"
      "superfile"
      "tfenv"
      "tldr"
      "tmux"
      "uv"
      "zoxide"
    ];
    casks = [
      "1password"
      "brave-browser"
      "claude-code"
      "datagrip"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "grammarly-desktop"
      "helium-browser"
      "intellij-idea"
      "postman"
      "spotify"
      "visual-studio-code"
    ];
  };
}
