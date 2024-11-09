# Enable true color support for the terminal
export TERM="xterm-256color"

# Some tools, like fzf, need this to be explicitly set for true color
export COLORTERM=truecolor

# Path for custom Zsh configuration
ZSH_CUSTOM="$HOME/.zsh"

# Set Powerlevel10k theme
source "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme"

# Enable Zsh plugins
source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Enable autosuggestions and syntax highlighting
# Other configurations for user convenience
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Keybindings for autosuggestions
bindkey '^ ' autosuggest-accept
