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
# This should correspond to a subdirectory that contains your dotfiles.
package="files"

# Set stow_target to /opt/atlenv if it exists, otherwise default to HOME
if [ -d "/opt/atlenv" ]; then
    stow_target="/opt/atlenv"
    stow_apply
    gum log -t rfc822 -s -l info "Files stowed successfully."
else
    stow_target="$HOME"
fi

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

gum log -t rfc822 -s -l info "All required commands are installed."

stow_confirm() {
    gum style --foreground "$text_info" "You are about to process the package '$package' using GNU Stow to the target directory $stow_target."
    gum confirm "Is this correct?" || {
        gum log -t rfc822 -s -l error "Operation cancelled."
        exit 1
    }
}

stow_apply() {
    gum log -t rfc822 -s -l info "Applying stow for package '$package' to $stow_target"
    stow -t "$stow_target" -v "$package"
}

stow_remove() {
    gum log -t rfc822 -s -l info "Removing stow symlinks for package '$package' from $stow_target"
    stow -t "$stow_target" -v -D "$package"
}

stow_check() {
    gum log -t rfc822 -s -l info "Performing a dry run for stow on package '$package' to $stow_target"
    stow -t "$stow_target" -v -n "$package"
}

options=(
    "Stow files"
    "Unstow files"
    "Dry run check"
)

# Use gum choose to display options
selected=$(gum choose --header "Please select a command" "${options[@]}")
gum log -t rfc822 -s -l info "You selected: $selected"
case $selected in
    "Stow files")
        stow_confirm
        stow_apply
        gum log -t rfc822 -s -l info "Files stowed successfully."
        ;;
    "Unstow files")
        stow_confirm
        stow_remove
        gum log -t rfc822 -s -l info "Files unstowed successfully."
        ;;
    "Dry run check")
        stow_check
        ;;
    *)
        gum log -t rfc822 -s -l error "Invalid option selected."
        exit 1
        ;;
esac
