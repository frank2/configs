#!/usr/bin/env bash

if [ -f "${HOME}/.bashrc_exports" ]; then
    source "${HOME}/.bashrc_exports"
fi

if [ -n "$INSIDE_EMACS" ]; then
    export PS1="\n[ \w ]\n\t \u@\H emacs> "
else
    export PS1="\n[ \w ]\n\t \u@\H \$ "
fi

case "$-" in
    *i*)
        if [ -z "$TMUX" ]; then
            tmux attach || tmux new
        fi
        
        POWERLINESH="$HOME/local/var/git/github/powerline/powerline/powerline/bindings/bash/powerline.sh"

        # setup powerline
        if [ -z "$INSIDE_EMACS" -a -f "$POWERLINESH" ]; then
            powerline-daemon -q
            POWERLINE_BASH_CONTINUATION=1
            POWERLINE_BASH_SELECT=1
            #source "$POWERLINESH"
        fi
        ;;
esac

# load the local rc file after the fact
if [ -f "$HOME/.bash_profile.local" ]; then
    source "$HOME/.bash_profile.local"
fi
