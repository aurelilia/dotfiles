# History
HISTFILE="$HOME/.local/share/zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# Environment variables
export BAT_THEME="base16"
export PROMPT_EOL_MARK="" # Partial line character

# Source global profile
emulate sh -c 'source /etc/profile'

# Opts
unsetopt beep # No beeping please
setopt no_beep # No beeping please
setopt extendedglob # Extended globbing features
setopt no_hup # Detach jobs from shell
setopt no_check_jobs # Don't check jobs when exiting shell
setopt clobber # Make '>' truncate
setopt share_history # Reloads history whenever you use it
setopt inc_append_history # Appends every command to the history file once it is executed
setopt no_auto_remove_slash # https://unix.stackexchange.com/questions/160026/how-can-i-keep-the-trailing-slash-after-choosing-a-directory-from-the-zsh-comple
setopt hist_ignore_all_dups # No duplicates in history

# Keybinds
bindkey -e
bindkey "^[[3~"   delete-char   # Delete key
bindkey "^[3;5~"  delete-char   # Delete key
bindkey "^[[1;5C" forward-word  # Ctrl+Right
bindkey "^[[1;5D" backward-word # Ctrl+Left

# Completion
zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 3 numeric


# zinit
source ~/.local/share/zinit/bin/zinit.zsh

# command-time
zinit light popstas/zsh-command-time
ZSH_COMMAND_TIME_MIN_SECONDS=2

# history-substring-search
zinit ice wait"0a" lucid
zinit light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# syntax highlighting
zinit ice wait"0b" lucid
zinit light zsh-users/zsh-syntax-highlighting
# highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)
# colors
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=blue,underline'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
# patterns
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_PATTERNS+=('rm*-rf*' 'fg=white,bold,bg=red')

# autosuggestions
zinit ice wait"0c" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# completions
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions \
    Aloxaf/fzf-tab

# minimal
zinit light subnixr/minimal
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty) # https://github.com/zsh-users/zsh-autosuggestions/issues/525

# Source everything from ~/.config/zsh/*.zsh
for f ("$HOME"/.config/zsh/*.zsh) . $f

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# zoxide
command -v zoxide > /dev/null && eval "$(zoxide init zsh)"
