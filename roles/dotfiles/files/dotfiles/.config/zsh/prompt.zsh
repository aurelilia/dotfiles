# Disable command_time printing
zsh_command_time() {}

function command_time() {
    if [ -n "$ZSH_COMMAND_TIME" ]; then
        hours=$(($ZSH_COMMAND_TIME/3600))
        min=$(($ZSH_COMMAND_TIME/60))
        sec=$(($ZSH_COMMAND_TIME%60))
        if [ "$ZSH_COMMAND_TIME" -le 60 ]; then
            timer_show="$fg[green]${ZSH_COMMAND_TIME}s"
        elif [ "$ZSH_COMMAND_TIME" -gt 60 ] && [ "$ZSH_COMMAND_TIME" -le 180 ]; then
            timer_show="$fg[yellow]${min}min${sec}s"
        else
            if [ "$hours" -gt 0 ]; then
                min=$(($min%60))
                timer_show="$fg[red]${hours}h${min}min${sec}s"
            else
                timer_show="$fg[red]${min}min${sec}s"
            fi
        fi
        printf "$fg[white]in $timer_show"
        unset ZSH_COMMAND_TIME
    fi
}

MNML_OK_COLOR=5
MNML_PROMPT=(mnml_ssh mnml_status mnml_fish_pwd command_time mnml_arrow)
MNML_RPROMPT=()

mnml_fish_pwd() {
    tput setaf 8
    print "$PWD" | sed -e "s|^$HOME|~|" -e 's|\(\.\{0,1\}[^/]\)[^/]*/|\1/|g'
}

mnml_arrow() {
    tput setaf 7
    printf "›"
}

mnml_me_ls() {
    lsd -lFh
}
