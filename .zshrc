# ~/.zshrc — The One True Config (Bazzite 2025 edition)
export ZDOTDIR="$HOME/.config/zsh"
export ZSH="$ZDOTDIR/.oh-my-zsh"
ZSH_CUSTOM="$ZSH/custom"
ZSH_CACHE_DIR="$ZDOTDIR/cache"
plugins=(themes web-search command-not-found copybuffer colored-man-pages)
ZSH_THEME=nanotechx
ZSH_THEME_RANDOM_CANDIDATES=( adbenx agnosterx avitx fino-timex foxx jonathanx nanotechx rkj-reposx robbyrussellx )
DEFAULT_USER=eric

# Source the Bazzite MOTD script
test -f /etc/profile.d/user-motd.sh && source /etc/profile.d/user-motd.sh
echo # <-- THIS LINE ADDS THE BLANK SPACE

# ────── HOST-ONLY SCRIPTS ──────
# Use this check to *only* run host-specific (Bazzite) scripts
# when we are NOT inside a distrobox container.
if [ -z "$CONTAINER_ID" ]; then

  # LOAD SYSTEM-WIDE SCRIPTS (FOR UJUST, ETC.)
  # Zsh doesn't read /etc/profile.d by default, so we do it here.
  if [ -d /etc/profile.d ]; then
    for i in /etc/profile.d/*.sh; do
      if [ -r "$i" ]; then
        . "$i"
      fi
    done
    unset i
  fi
fi

# ────── CONTAINER-ONLY SCRIPTS ──────
if [ -n "$CONTAINER_ID" ]; then
  # This fixes the 'append_path' error *inside* Arch
  # Source this *before* OMZ to define functions
  source /etc/profile
fi

# ────── OH-MY-ZSH ──────
source $ZSH/oh-my-zsh.sh

# ────── POST-OMZ TWEAKS ──────
# --------------------------------------------------------------------
# This is the "best practice" for adding context to OMZ themes.
# We redefine the 'prompt_context' function that themes use.
# This inserts the container ID *inside* the theme's formatting.
# 1. First, check if the theme even defined this function
if (( ${+functions[prompt_context]} )); then
# 2. If it did, store a reference to the *original* function
  functions[original_prompt_context]=${functions[prompt_context]}
# 3. Now, create our new function
  prompt_context() {
    if [ -n "$CONTAINER_ID" ]; then
# If we're in a container, add our info (styled cyan)
      echo -n "%F{cyan}  $CONTAINER_ID%f "
    fi
# Call the theme's original function (which prints user@host)
    original_prompt_context
  }
fi

if [[ -e /.dockerenv ]] ; then
    psvar[1]="@${(%):-%m} «Docker»"     # show hostname inside docker containers
elif [[ -e /run/.containerenv ]] ; then
    psvar[1]="@${(%):-%m} «Podman»"     # show hostname inside podman containers
fi

# ────── ZSH OPTIONS ──────
# Lines configured by zsh-newuser-install
setopt autocd extendedglob notify prompt_subst
setopt appendhistory extended_history hist_ignore_all_dups hist_ignore_space
unsetopt beep
bindkey -v

# The following lines were added by compinstall
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

# ────── COMMON SHELL CONFIG ──────
[ -f "$ZDOTDIR/commonrc" ] && source "$ZDOTDIR/commonrc"

# Shell-specific inits
[ "$(command -v atuin)" ] && eval "$(atuin init zsh)"
[ "$(command -v zoxide)" ] && eval "$(zoxide init zsh)"

