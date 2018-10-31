#!/bin/bash

color_off='\e[0m'       # Text Reset
black_bg='\e[0;100m'    # Black background
color[0]='\e[0;31m'     # Red
color[1]='\e[0;32m'     # Green
color[2]='\e[0;33m'     # Yellow
color[3]='\e[0;34m'     # Blue
color[4]='\e[0;35m'     # Purple
color[5]='\e[0;36m'     # Cyan
color[6]='\e[0;37m'     # White

talk_file="/tmp/chat"       # File with chat log

function print_help {
    echo "Available commands are:"
    echo "  /quit"
    echo "  /help"
    echo "  /users"
}

function print_command_error {
    echo "Error: '$@' is not an available command"
}

function print_motd {
    if [ -f ./motd ]
    then
        cat ./motd
    fi
}

function random_color {
    random=$(($RANDOM % 6))
    color=${color[$random]}
}

function create_talk {
    if [ ! -f $talk_file ]
    then
        touch $talk_file
        chmod a+rw $talk_file
    fi
}

function echo_msg {
    date=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "$black_bg $date ${color}$USER${color_off} $@" >> $talk_file
}

function command_txt {
    if [ "$@" = "/quit" ]
    then
        tmux -L chat kill-server
        exit 0
    elif [ "$@" = "/help" ]
    then
        print_help
    elif [ "$@" = "/users" ]
    then
        w -h | cut -f 1 -d " " | sort -u
    else
        print_command_error "$@"
    fi
}

function input_txt {
    if [ -z "$@" ]
    then
        return
    elif [ "$(echo $@ | cut -c1 )" = "/" ]
    then
        command_txt "$@"
    else
        echo_msg "$@"
    fi
}

create_talk
random_color

if [ "$1" = "out" ]
then
    print_motd
    tail -F $talk_file 2> /dev/null
elif [ "$1" = "in" ]
then
    while true
    do
        echo -ne "$black_bg --> $color_off"
        read line
        sanitized_line=$(tr -d "[:cntrl:]" <<< "$line")
        input_txt "$sanitized_line"
    done
else
    tmux -L chat new-session -d
    tmux -L chat source-file /tmux.conf
    tmux -L chat kill-server
fi
