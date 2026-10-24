{ config, lib, pkgs, vars, ... }:

let
  inherit (vars) dotfiles;
in
{
  home = {
    username = vars.user;
    inherit (vars) homeDirectory;
    stateVersion = "26.05";

    file = {
      ".zprofile".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.zprofile";

      ".config" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config";
        recursive = true;
        ignorelinks = true;
      };

      "Library/Application Support/Code/User" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/vscode";
        recursive = true;
        ignorelinks = true;
      };

      ".pi" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/agents/pi/.pi";
        recursive = true;
        ignorelinks = true;
      };

      ".omp" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/agents/omp/.omp";
        recursive = true;
        ignorelinks = true;
      };

      ".claude" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/agents/claude/.claude";
        recursive = true;
        ignorelinks = true;
      };
    };
  };

  programs.home-manager.enable = true;

  launchd.agents.wallpaper = {
    enable = true;

    config = {
      ProgramArguments = [
        (lib.getExe pkgs.desktoppr)
          "${dotfiles}/assets/wallpapers/dNjVBEB.png"
      ];

      RunAtLoad = true;
    };
  };
}
