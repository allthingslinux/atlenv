#!/bin/bash

# color presets
text_info=135
text_error=196
text_success=46

# Required commands to check
required_commands=(
    "eza"
    "zoxide"
    "thefuck"
    "gum"
    "starship"
)

files_to_symlink=(
    ".zshrc"
    ".zsh_aliases"
    "bin/"
)

symlink_to_dir=$HOME

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

symlink_confirm() {
    gum style --foreground "$text_info" "You are about to symlink/unsymlink the following files to $symlink_to_dir:"
    for file in "${files_to_symlink[@]}"; do
        gum style --foreground "$text_info" "$file"
    done
    gum confirm "Please confirm the above information is correct" || {
        gum log -t rfc822 -s -l error "Operation cancelled."
        exit 1
    }
}

symlink_add() {
    for file in "${files_to_symlink[@]}"; do
        if [ -e "$symlink_to_dir/$file" ]; then
            # log and quit
            gum log -t rfc822 -s -l error "$file already exists in $symlink_to_dir. Please remove it first."
        fi
        gum log -t rfc822 -s -l info "Creating symlink for $file in $symlink_to_dir"
        ln -s "$(pwd)/$file" "$symlink_to_dir/$file"
    done
}

symlink_remove() {
    for file in "${files_to_symlink[@]}"; do
        if [ ! -e "$symlink_to_dir/$file" ]; then
            # log and quit
            gum log -t rfc822 -s -l error "$file does not exist in $symlink_to_dir. Please check the path."
        fi
        gum log -t rfc822 -s -l info "Removing symlink for $file in $symlink_to_dir"
        rm "$symlink_to_dir/$file"
    done
}

symlink_check() {
    for file in "${files_to_symlink[@]}"; do
        if [ -L "$symlink_to_dir/$file" ]; then
            gum log -t rfc822 -s -l info "$file is a symlink in $symlink_to_dir"
        else
            gum log -t rfc822 -s -l error "$file is not a symlink in $symlink_to_dir"
        fi
    done
}

options=(
    "Symlink files"
    "Remove symlinks"
    "Check symlinks"
)
# use gum choose to display options
selected=$(gum choose --header "Please select a command" "${options[@]}")
gum log -t rfc822 -s -l info "You selected: $selected"
case $selected in
    "Symlink files")
        symlink_confirm
        symlink_add
        gum log -t rfc822 -s -l success "Symlinks created successfully."
        ;;
    "Remove symlinks")
        symlink_confirm
        symlink_remove
        gum log -t rfc822 -s -l success "Symlinks removed successfully."
        ;;
    "Check symlinks")
        symlink_check
        ;;
    *)
        gum log -t rfc822 -s -l error "Invalid option selected."
        exit 1
        ;;
esac
