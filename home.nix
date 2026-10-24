{ config, lib, vars, ... }:

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
      in
      if ignored name then { }
      else if type == "directory" then filesUnder sourcePath targetPath
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
      ".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/agents/shared/AGENTS.md";
    }
    // filesUnder ".config" ".config"
    // filesUnder "vscode" "Library/Application Support/Code/User"
    // filesUnder "agents/pi/.pi" ".pi"
    // filesUnder "agents/omp/.omp" ".omp"
    // filesUnder "agents/claude/.claude/rules" ".claude/rules"
    // filesUnder "agents/claude/.claude/output-styles" ".claude/output-styles"
    // filesUnder "agents/shared/skills" ".claude/skills";
  };

  programs.home-manager.enable = true;
}
