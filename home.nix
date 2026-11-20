{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  inherit (vars) dotfiles;

  symlink = config.lib.file.mkOutOfStoreSymlink;

  ignored = name: name == ".DS_Store" || name == ".nvimlog" || lib.hasSuffix ".swp" name;

  recursiveSymlink =
    source: target:
    let
      entries = builtins.readDir (./. + "/${source}");
    in
    lib.concatMapAttrs (
      name: type:
      let
        sourcePath = "${source}/${name}";
        targetPath = "${target}/${name}";
      in
      if ignored name then
        { }
      else if type == "directory" then
        recursiveSymlink sourcePath targetPath
      else if type == "regular" || type == "symlink" then
        {
          "${targetPath}".source = symlink "${dotfiles}/${sourcePath}";
        }
      else
        { }
    ) entries;
in
{
  home = {
    username = vars.user;
    inherit (vars) homeDirectory;
    stateVersion = "26.05";

    file = {
      ".zprofile".source = symlink "${dotfiles}/.zprofile";
    }
    // (recursiveSymlink "vscode" "Library/Application Support/Code/User")
    // (recursiveSymlink "agents/pi/.pi" ".pi")
    // (recursiveSymlink "agents/omp/.omp" ".omp")
    // (recursiveSymlink "agents/claude/.claude" ".claude");
  };

  xdg.configFile = {
    "fsh/catppuccin-mocha.ini".source = symlink "${dotfiles}/.config/fsh/catppuccin-mocha.ini";
    "ghostty/config".source = symlink "${dotfiles}/.config/ghostty/config";
    "git/settings".source = symlink "${dotfiles}/.config/git/settings";
    "herdr/config.toml".source = symlink "${dotfiles}/.config/herdr/config.toml";
    "rumdl/rumdl.toml".source = symlink "${dotfiles}/.config/rumdl/rumdl.toml";
    "starship.toml".source = symlink "${dotfiles}/.config/starship.toml";
    "rtk/config.toml".source = symlink "${dotfiles}/.config/rtk/config.toml";
    "llama/models.ini".source = symlink "${dotfiles}/.config/llama/models.ini";
  }
  // (recursiveSymlink ".config/superfile" "superfile")
  // (recursiveSymlink ".config/nvim" "nvim")
  // (recursiveSymlink ".config/zsh" "zsh");

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

  programs = {
    home-manager.enable = true;

    obsidian = {
      enable = true;
      package = null;

      vaults.notes = {
        target = "Documents/Obsidian Vault";

        settings = {
          app = {
            alwaysUpdateLinks = true;
            spellcheck = true;
            showLineNumber = true;
            readableLineLength = false;
            autoPairBrackets = true;
            autoPairMarkdown = true;
          };

          appearance = {
            theme = "system";
            accentColor = "#f38ba8";
            baseFontSize = 16;
            showRibbon = false;
          };

          corePlugins = [
            "backlink"
            "bookmarks"
            "canvas"
            "command-palette"
            "file-explorer"
            "file-recovery"
            "global-search"
            "graph"
            "outline"
            "page-preview"
            "properties"
            "switcher"
            "templates"
            "word-count"
            "workspaces"
          ];

          communityPlugins = with pkgs.obsidianPlugins; [
            obsidian-editor-shortcuts
            obsidian-excalidraw-plugin
            {
              pkg = obsidian-git;
              settings = builtins.fromJSON (builtins.readFile ./obsidian/plugins/obsidian-git/data.json);
            }
          ];

          hotkeys = builtins.fromJSON (builtins.readFile ./obsidian/hotkeys.json);

          themes = with pkgs.obsidianThemes; [
            minimal
          ];

          cssSnippets = null;
          extraFiles = null;
        };
      };
    };
  };

}
