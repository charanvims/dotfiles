# ------------------ History ------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# ------------------ Prompt (Starship) ------------------
eval "$(starship init zsh)"

# ------------------ Completion & Correction ------------------
# Basic completion (no autosuggestions or plugins)
autoload -Uz compinit && compinit
setopt CORRECT

# ------------------ Globbing ------------------
setopt EXTENDED_GLOB

# ------------------ Key Bindings ------------------
bindkey -e
bindkey '^R' history-incremental-search-backward
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# ------------------ Aliases ------------------
alias ls='ls --color=auto'
alias ll='ls -la'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gco='git checkout'
alias gpl='git pull'
alias gps='git push'

alias install='sudo pacman -S'
alias update='sudo pacman -Syu'
alias zshconf='nvim ~/.zshrc'
alias srczsh='source ~/.zshrc'
alias kittyconf='nvim ~/.config/kitty/kitty.conf'
alias crittyconf='nvim ~/.config/alacritty/alacritty.toml'
alias starconf='nvim ~/.config/starship.toml'
command -v nvim &>/dev/null && alias vim='nvim'

# ------------------ PATH ------------------
export PATH="$HOME/.local/bin:$PATH"
