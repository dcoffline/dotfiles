# Bootstrapper — causes the real config to be loaded from dotfiles
export DEFAULT_USER=eric
export HOME="${HOME:-/home/eric}"
export ZDOTDIR="${ZDOTDIR:-$HOME/src/github.com/dcoffline/dotfiles/zsh}"
source $ZDOTDIR/.secrets
source $ZDOTDIR/.monitors
