# ~/.zshrc — The One True Config (Bazzite 2025 edition)

# Shell Exports
ZSH="$HOME/.config/ohmyzsh"
ZSH_CUSTOM="$ZSH/custom"
ZSH_CACHE_DIR="$ZSH/cache"
ZSH_THEME=nanotechx  
ZSH_THEME_RANDOM_CANDIDATES=( agnosterx avitx fino-timex foxx jonathanx nanotechx rkj-reposx robbyrussellx )

mkdir -p "$ZSH_CACHE_DIR"

# OMZ Plugins
plugins=(themes web-search command-not-found copybuffer colored-man-pages git)


# ────── OH-MY-ZSH ──────
source $ZSH/oh-my-zsh.sh

# ────── POST-OMZ TWEAKS ──────
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
[ -f "$ZDOTDIR/.shrc" ] && source "$ZDOTDIR/.shrc"

# Shell-specific inits
[ "$(command -v atuin)" ] && eval "$(atuin init zsh)"
[ "$(command -v zoxide)" ] && eval "$(zoxide init zsh)"
if [ "$(command -v fzf)" ]; then
    source <(fzf --zsh)
    export FZF_BASE=/usr/share/fzf
    export FZF_DEFAULT_COMMAND='fd --type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d'
fi

echo # <-- THIS LINE ADDS THE BLANK SPACE
