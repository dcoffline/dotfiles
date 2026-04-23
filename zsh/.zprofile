# This file is ~/.config/zsh/.zprofile and pointed to by ~/.zshenv

# prepend ~/.local/bin to $PATH unless it is already there
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH
