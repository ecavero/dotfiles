# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

- **bash**: `.bashrc`, `.bash_aliases`, `.bash_logout`, `.profile`
- **vim**: `.vimrc` (with Vundle and LSP support)
- **git**: `.gitconfig`
- **tmux**: `.tmux.conf`
- **zsh**: `.zshrc`
- **secrets**: `.secrets` (gitignored, contains sensitive data)

## Installation

### Prerequisites

```bash
# Install stow
sudo apt install stow
```

### Setup

1. Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
```

2. Create symlinks:

```bash
cd ~/.dotfiles
stow bash vim git tmux zsh secrets
```

3. Configure secrets:

```bash
cp ~/.dotfiles/secrets/.secrets.example ~/.secrets
chmod 600 ~/.secrets
# Edit ~/.secrets with your values
nano ~/.secrets
```

4. Reload shell:

```bash
source ~/.profile
```

## Structure

```
~/.dotfiles/
├── bash/
│   ├── .bashrc
│   ├── .bash_aliases
│   ├── .bash_logout
│   └── .profile
├── vim/
│   └── .vimrc
├── git/
│   └── .gitconfig
├── tmux/
│   └── .tmux.conf
├── zsh/
│   └── .zshrc
├── secrets/
│   ├── .secrets          # gitignored - your actual secrets
│   └── .secrets.example  # template for new installations
├── .gitignore
└── README.md
```

## Uninstall

To remove symlinks:

```bash
cd ~/.dotfiles
stow -D bash vim git tmux zsh secrets
```

## Adding new dotfiles

1. Create a new directory in `~/.dotfiles/` (e.g., `alacritty/`)
2. Move the config file there (e.g., `~/.dotfiles/alacritty/.alacritty.yml`)
3. Run `stow alacritty` to create the symlink
4. Commit and push

## License

MIT
