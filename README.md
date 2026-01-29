# Dotfiles

My dotfiles configurations managed by stow.

Install bundle:

```sh
brew bundle install --file ./.config/homebrew/Brewfile
```

Symlink to parent directory:

```sh
stow .
```

Symlink Viual Studio Code settings:

```sh
stow --target "$HOME/Library/Application Support/Code/User" vscode
```

Include git settings in `~/.config/git/config`:

```ini
[include]
  path = settings
```

Sample `.ssh/config`:

```ini
Include config.d/*.conf

Host github.com
  AddKeysToAgent yes
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_rsa

Host github.com:<USERNAME>
  Host github.com
  AddKeysToAgent yes
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519_<USERNAME>
```
Setup themes:
```sh
fast-theme XDG:catppuccin-mocha
```
