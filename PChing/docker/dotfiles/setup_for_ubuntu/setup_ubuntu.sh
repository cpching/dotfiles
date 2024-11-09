#!/bin/bash

LOGFILE="$HOME/setup.log"
VERBOSE=true

if [[ "$(uname)" == "Darwin" ]]; then
    OS="macos"
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID  # This will be "alpine" for Alpine Linux
else
    OS=""  # This will be "alpine" for Alpine Linux
    log "Unsupported OS. This script supports macOS, Alpine, Ubuntu, and Debian."
fi


if [[ "$OS" != "ubuntu" ]]; then
    log "Unsupported OS. This script supports Ubuntu."
    exit 1
fi

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if sudo is available
USE_SUDO=true
if ! command_exists sudo; then
    USE_SUDO=false
fi


# Logging function
log() {
    local message="$1"
    echo "$message" | tee -a "$LOGFILE"  # Write to both console and log file
}

# Verbose logging function
verbose_log() {
    if [ "$VERBOSE" = true ]; then
        log "$1"
    else
        echo "$1" >> "$LOGFILE"  # Only log to the file if not verbose
        fi
}

initialize_setup() {
    if [ "$USE_SUDO" = true ]; then
        sudo apt update && apt upgrade -y
    else
        apt update && apt upgrade -y
    fi
}

install_app() {
    local app_name="$1"

    if command_exists "$app_name"; then
        verbose_log "$app_name is already installed."
    else
        log "Installing $app_name..."
        if [ "$USE_SUDO" = true ]; then
            sudo apt install -y "$app_name"
        else
            apt install -y "$app_name"
        fi
        log "$app_name installation completed."
    fi
}

configure_zsh() {
    # Set Zsh as the default shell
    echo "Setting Zsh as the default shell..."
    chsh -s $(which zsh)

    # Install Zsh plugins
    echo "Installing Zsh plugins..."

    # Create a directory for Zsh plugins
    ZSH_CUSTOM="$HOME/.zsh"
    mkdir -p "$ZSH_CUSTOM/plugins"

    # Install zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

    # Install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

    # Install Powerlevel10k theme
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

    # Configure .zshrc
    echo "Configuring .zshrc for plugins and Powerlevel10k..."


    # Install Python3 and pip
    echo "Installing Python3 and pip..."
    sudo apt install -y python3 python3-pip

    # Configure autojump
    configure_autojump

    # Source .zshrc
    echo "Sourcing .zshrc..."
    source ~/.zshrc
}

setup_autojump() {
    # Add autojump to .zshrc if it's installed
    if command_exists "autojump"; then
        if ! grep -q "^[ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh" ~/.zshrc; then
            echo "Configuring autojump in .zshrc..."
            echo '[ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh' >> ~/.zshrc
            echo "autojump configuration added to .zshrc."
        else
            verbose_log "autojump is already configured in .zshrc."
        fi
    fi
}

# Install fzf from GitHub (recommended method)
install_fzf() {
    if command_exists fzf; then
        verbose_log "fzf is already installed."
    else
        log "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
        log "fzf installation completed."
    fi
}


# Install fd-find
install_fd() {
    if command_exists fd; then
        verbose_log "fd is already installed."
    else
        log "Installing fd-find..."
        if [ "$USE_SUDO" = true ]; then
            sudo apt install -y fd-find
        else
            apt install -y fd-find
        fi
        log "fd installation completed."
    fi
}

# Install Neovim 0.10
install_nvim() {
    if command_exists nvim && nvim --version | grep -q "NVIM v0.10"; then
        verbose_log "Neovim v0.10 is already installed."
    else
        log "Installing Neovim v0.10..."
        if [ "$USE_SUDO" = true ]; then
            sudo apt install -y wget
            wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.deb
            sudo apt install ./nvim-linux64.deb
            rm ./nvim-linux64.deb
        else
            apt install -y wget
            wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.deb
            apt install ./nvim-linux64.deb
            rm ./nvim-linux64.deb
        fi
        log "Neovim v0.10 installation completed."
    fi
}

configure_fzf() {
    # Configure fzf to use fd in .zshrc
if command_exists "fd"; then
    if ! grep -q "FZF_DEFAULT_COMMAND" ~/.zshrc; then
        log "Configuring fzf to use fd in .zshrc..."

        echo 'export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"' >> ~/.zshrc
        echo 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"' >> ~/.zshrc
        echo 'export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"' >> ~/.zshrc
         echo 'export FZF_DEFAULT_OPTS="--height 40% --reverse --border --bind=ALT-j:down,ALT-k:up"' >> ~/.zshrc
        echo 'export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'\'' \
      --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#121212,bg+:#262626 \
      --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#e35454 \
      --color=prompt:#0084d6,spinner:#af5fff,pointer:#d7e355,header:#87afaf \
      --color=border:#262626,label:#aeaeae,query:#d9d9d9 \
      --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> " \
      --marker=">" --pointer=">" --separator="─" --scrollbar="│" \
      --info="right"'\''' >> ~/.zshrc

        log "fzf configuration with fd added to .zshrc."
    else
        verbose_log "fzf is already configured to use fd in .zshrc."
    fi
fi
}

# echo "Updating and upgrading system packages..."
initialize_setup
echo "Installing essential packages..."
install_app "zsh"
install_app "git"
install_app "curl"
install_app "autojump"
configure_zsh

# Install fzf, fd, and Neovim
install_fzf
install_fd
install_nvim
configure_fzf

