# Dotfiles

nix-darwin manages macOS settings and Homebrew packages.
Home Manager manages the configuration links through nix-darwin.

## Install

Install Nix with the [macOS instructions in the Nix manual][nix-install].

Keep the repository at `~/.dotfiles`. The `macos` configuration targets Apple Silicon macOS.

For another account, change `user` in `flake.nix`.
For an Intel Mac, change `nixpkgs.hostPlatform` in `configuration.nix` to `x86_64-darwin`.

If `darwin-rebuild` is not available, build the initial configuration with:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' \
  run github:nix-darwin/nix-darwin/nix-darwin-26.05 -- switch --flake "$HOME/.dotfiles#macos"
```

Start a new login shell after activation.

## Build and apply

Build the configuration without activation:

```sh
bash "$HOME/.dotfiles/rebuild.sh"
```

Apply the configuration explicitly:

```sh
bash "$HOME/.dotfiles/rebuild.sh" --apply
```

Requires `sudo`.

The first activation migrates an existing Homebrew installation to nix-homebrew. It keeps installed packages.

## JetBrains

Replace `IntelliJIdea2026.2` with your product and version.
Move existing target files before you create the links.

```sh
target="$HOME/Library/Application Support/JetBrains/IntelliJIdea2026.2"
mkdir -p "$target/keymaps" "$target/options/mac"
ln -s "$HOME/.dotfiles/jetbrains/keymaps/macos-copy.xml" "$target/keymaps/macos-copy.xml"
ln -s "$HOME/.dotfiles/jetbrains/options/mac/keymap.xml" "$target/options/mac/keymap.xml"
```

## Update Nix inputs

Update the pinned Nixpkgs, nix-darwin, nix-homebrew, and Home Manager inputs, then build:

```sh
nix flake update --flake "$HOME/.dotfiles"
bash "$HOME/.dotfiles/rebuild.sh"
```

Apply the updated configuration with `--apply` after you check the build result.

Keep `home.stateVersion` and `system.stateVersion` unchanged unless the relevant release notes tell you to change them.

## Git and SSH

Include Git settings in `~/.config/git/config`:

```ini
[include]
  path = settings
```

Example `~/.ssh/config`:

```ini
Include config.d/*.conf

Host github.com
  AddKeysToAgent yes
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_rsa

Host github-<USERNAME>
  Host github.com
  AddKeysToAgent yes
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519_<USERNAME>
```

## Shell theme

Apply the theme:

```sh
fast-theme XDG:catppuccin-mocha
```

___

## Links

[nix-install]: https://nix.dev/manual/nix/stable/installation/installing-binary.html
