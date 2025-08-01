{ config, ... }:
{
  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  feline.shellAliases = {
    o = "xdg-open";
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    # Handled by zinit
    enableCompletion = false;

    history = {
      path = "${config.xdg.dataHome}/zsh_history";
      size = 50000;
      ignoreAllDups = true;
      share = true;
    };

    shellAliases = config.feline.shellAliases;
    initContent = ''
      # Quiet direnv
      export DIRENV_LOG_FORMAT=""

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
      zstyle ':completion:*' cache-path $HOME/.cache/zsh/zcompcache

      # zinit
      ZINIT_HOME="${config.home.homeDirectory}/.local/share/zinit/bin"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "${config.home.homeDirectory}/.local/share/zinit/bin/zinit.zsh"

      # syntax highlighting
      zinit ice wait"0b" lucid
      zinit light zsh-users/zsh-syntax-highlighting

      # history-substring-search
      zinit ice wait"0a" lucid
      zinit light zsh-users/zsh-history-substring-search
      bindkey '^[OA' history-substring-search-up
      bindkey '^[OB' history-substring-search-down

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
