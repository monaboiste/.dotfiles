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
  }
  // (recursiveSymlink ".config/superfile" "superfile")
  // (recursiveSymlink ".config/nvim" "nvim")
  // (recursiveSymlink ".config/zsh" "zsh");

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
