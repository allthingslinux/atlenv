#!/bin/bash

# Color presets
text_info=135
text_error=196

# Required commands to check
required_commands=(
    "eza"
    "zoxide"
    "thefuck"
    "gum"
    "starship"
    "stow"
)

# Define your package name for stow.
package="files"
stow_target=$HOME

# Check if zsh is the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Zsh is not the default shell. Please set it as the default shell."
    exit 1
fi

# Check if required commands are installed
for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd could not be found. Please install it."
        exit 1
    fi
done

echo "All required commands are installed."

stow_apply() {
    echo "Applying stow for package '$package' to $stow_target"
    stow -t "$stow_target" -v "$package"
}

stow_remove() {
    echo "Removing stow symlinks for package '$package' from $stow_target"
    stow -t "$stow_target" -v -D "$package"
}

stow_check() {
    echo "Performing a dry run for stow on package '$package' to $stow_target"
    stow -t "$stow_target" -v -n "$package"
}

# Simulate default choice for automation
if [ -t 0 ]; then
    options=(
        "Stow files"
        "Unstow files"
        "Dry run check"
    )

    selected=$(printf "%s\n" "${options[@]}" | gum choose --header "Please select a command")
else
    selected="Stow files"  # Default choice in automation mode
fi

echo "You selected: $selected"
case $selected in
    "Stow files")
        stow_apply
        echo "Files stowed successfully."
        ;;
    "Unstow files")
        stow_remove
        echo "Files unstowed successfully."
        ;;
    "Dry run check")
        stow_check
        ;;
    *)
        echo "Invalid option selected."
        exit 1
        ;;
esac
