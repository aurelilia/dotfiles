{ config, pkgs, ... }:
{
  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autocd = true;
    # Handled by zinit
    enableCompletion = false; 

    history = {
      path = "${config.xdg.dataHome}/zsh_history";
      size = 50000;
      ignoreAllDups = true;
      share = true;
    };

    initExtra =''
      if [ -e /home/leela/.nix-profile/etc/profile.d/nix.sh ]; then . /home/leela/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

      # Opts
      unsetopt beep # No beeping please
      setopt no_beep # No beeping please
      setopt extendedglob # Extended globbing features
      setopt no_hup # Detach jobs from shell
      setopt no_check_jobs # Don't check jobs when exiting shell
      setopt clobber # Make '>' truncate
      setopt inc_append_history # Appends every command to the history file once it is executed
      setopt no_auto_remove_slash # https://unix.stackexchange.com/questions/160026/how-can-i-keep-the-trailing-slash-after-choosing-a-directory-from-the-zsh-comple

      # Keybinds
      bindkey -e
      bindkey "^[[3~"   delete-char   # Delete key
      bindkey "^[3;5~"  delete-char   # Delete key
      bindkey "^[[1;5C" forward-word  # Ctrl+Right
      bindkey "^[[1;5D" backward-word # Ctrl+Left

      # Completion
      zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' completer _complete _match _approximate
      zstyle ':completion:*:approximate:*' max-errors 3 numeric
      zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
      
      # zinit
      ZINIT_HOME="/home/leela/.local/share/zinit/bin"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "/home/leela/.local/share/zinit/bin/zinit.zsh"

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

      # history-substring-search
      zinit ice wait"0a" lucid
      zinit light zsh-users/zsh-history-substring-search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # autosuggestions
      zinit ice wait"0c" lucid atload"_zsh_autosuggest_start"
      zinit light zsh-users/zsh-autosuggestions

      # completions
      zinit wait lucid atload"zicompinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION; zicdreplay" blockf for \
          zsh-users/zsh-completions \
          Aloxaf/fzf-tab

      # fzf
      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    '';
  };
}