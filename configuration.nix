{ vars, ... }:

{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      interval = {
        Weekday = 6;
        Hour = 3;
        Minute = 15;
      };
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  nixpkgs.hostPlatform = vars.hostPlatform;

  users.users.${vars.user} = {
    home = vars.homeDirectory;
  };

  system = {
    primaryUser = vars.user;
    stateVersion = 6;
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        KeyRepeat = 2; # fast key repeat
        InitialKeyRepeat = 15; # short delay before repeat
        _HIHideMenuBar = false; # auto-hide the menu bar
        AppleShowAllExtensions = true;
      };
      dock.autohide = true;
      finder.FXPreferredViewStyle = "Nlsv"; # list view by default
      finder.CreateDesktop = false; # clean desktop
      trackpad.Clicking = true; # tap to click
      CustomUserPreferences = {
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # select the previous input source (ctrl+space)
            "60" = {
              enabled = false;
            };
            # select next source in input menu (ctrl+alt+space)
            "61" = {
              enabled = false;
            };
          };
        };
      };
    };
    activationScripts.postActivation.text = ''
      # apply without logout/login cycle
      sudo -u ${vars.user} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  nix-homebrew = {
    enable = true;
    autoMigrate = true;
    inherit (vars) user;
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
      "nixfmt"
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
      "obsidian"
      "visual-studio-code"
    ];
  };
}
