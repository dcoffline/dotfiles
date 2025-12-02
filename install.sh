# 1. Clone your masterpiece into the right place
git clone https://github.com/dcoffline/dotfiles.git "$HOME/.config/zsh"

# 2. Create the tiny bootstrapper in your real home (this is the ONLY file that lives in ~)
cat >"$HOME/.zshenv" <<'EOF'
# Bootstrapper — loads the real config from ~/.config/zsh
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
EOF

# 3. (Optional but recommended) Make sure the history file exists so zsh doesn't whine
mkdir -p "$ZDOTDIR"
touch "$ZDOTDIR/.histfile"

# 4. Open a new terminal (or source ~/.zshrc) and watch the magic
exec zsh
