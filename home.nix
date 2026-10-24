{ config, lib, pkgs, vars, ... }:

let
  inherit (vars) dotfiles;
  ignored = name:
    name == ".DS_Store"
    || name == ".nvimlog"
    || lib.hasSuffix ".swp" name
    || lib.hasSuffix ".zsh_sessions" name;

  filesUnder = source: target:
    let
      entries = builtins.readDir (./. + "/${source}");
    in
    lib.concatMapAttrs (name: type:
      let
        sourcePath = "${source}/${name}";
        targetPath = "${target}/${name}";
        isDirectory = type == "directory"
          || (type == "symlink" && builtins.pathExists "${./.}/${sourcePath}/.");
      in
      if ignored name then { }
      else if isDirectory then filesUnder sourcePath targetPath
      else {
        ${targetPath}.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${sourcePath}";
      }
    ) entries;
in
{
  home = {
    username = vars.user;
    inherit (vars) homeDirectory;
    stateVersion = "26.05";

    file = {
      ".zprofile".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.zprofile";
    }
    // filesUnder ".config" ".config"
    // filesUnder "vscode" "Library/Application Support/Code/User"
    // filesUnder "agents/pi/.pi" ".pi"
    // filesUnder "agents/omp/.omp" ".omp"
    // filesUnder "agents/claude/.claude" ".claude";
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
