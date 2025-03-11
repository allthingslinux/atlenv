# get time it took to finish loading in ms
start=$(date +%s%N)

# zoxide
eval "$(zoxide init zsh)"

# thefuck
eval $(thefuck --alias)

# aliases
source $HOME/.zsh_aliases

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh" # kitty sucks so we have to do this

# history
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt appendhistory

# make some keys work
bindkey '^[[1;5C' emacs-forward-word 
bindkey '^[[1;5D' emacs-backward-word

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# print welcome message
echo -e "\x1b[35mHello, \x1b[32m$USER!\x1b[0m"
echo -e "\x1b[35mThe time is \x1b[32m$(date +"%r")\x1b[0m"

# starship prompt
eval "$(starship init zsh)"

# autocomplete & syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

end=$(date +%s%N)
echo -e "\x1b[35mShell loaded in \x1b[32m$((($end - $start) / 1000000))ms!\x1b[0m"
