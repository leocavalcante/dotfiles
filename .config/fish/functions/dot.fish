function dot --description "Update dotfiles from repository"
    set -l dotfiles_dir $HOME/.dotfiles
    echo "Starting dotfiles update process"

    if not cd $dotfiles_dir
        echo "Could not find the .dotfiles directory!" >&2
        return 1
    end

    echo "Pulling latest changes from git repository..."
    git pull --quiet; and echo "Repository updated."

    if command -q stow
        echo "Restowing dotfiles using GNU Stow..."
        stow .; and echo "Dotfiles stowed successfully."
    else
        echo "GNU Stow not installed! Please install it to continue." >&2
    end

    cd $HOME; or begin
        echo "Could not return to the home directory!" >&2
        return 1
    end
    echo "Dotfiles update process completed."
end
