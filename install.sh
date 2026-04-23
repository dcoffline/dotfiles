#!/bin/bash
sudo -v
# Define the source of truth
DOTFILES_DIR="$HOME/src/github.com/dcoffline/dotfiles"

# 1. Ensure vital parent directories exist
mkdir -p ~/.config ~/.local/bin

# 2. Symlink the Zsh pointer
# Using -f to overwrite any existing pointer
ln -sf "$DOTFILES_DIR/config/zsh/.zshenv" "$HOME/.zshenv"

# 3. Ensure Homebrew is ready and install tools
# This handles your CLI power-tools
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES_DIR/Brewfile"
else
  echo "Homebrew not found. Install it first to process the Brewfile."
fi

# 4. Ensure Stow is installed
command -v stow >/dev/null 2>&1 || brew install stow

# 5. Run the stow command
# -t ~ sets the target to home
# -d sets the source to your repo
stow -v -t "$HOME" -d "$DOTFILES_DIR" config
cp $DOTFILES_DIR/system/cloudflared.service /etc/systemd/system
cp $DOTFILES_DIR/system/rclone-mounts.service /etc/systemd/system

echo "Fortress installation complete. Reload your shell to see changes."
