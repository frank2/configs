# if we're inside emacs, it only calls .bashrc because I guess it's not... interactive... even though it is.
if [ -n "$INSIDE_EMACS" ]; then
    export PS1="\n[ \w ]\n\t \u@\H emacs> "
else
    export PS1="\n[ \w ]\n\t \u@\H \$ "
fi

export PATH="$HOME/.local/bin:$HOME/local/bin:$PATH"
export PYTHONPATH="$HOME/local/lib/python:$PYTHONPATH"
export EDITOR="emacs -nw"
export TERM="xterm-256color"
export LANG="en_US.UTF-8"

alias ls="ls --color"
alias vim="emacs -nw"

case "$-" in
    *i*)
        POWERLINESH="$HOME/local/var/git/github/powerline/powerline/powerline/bindings/bash/powerline.sh"

        # setup powerline
        if [ -z "$INSIDE_EMACS" -a -f "$POWERLINESH" ]; then
            powerline-daemon -q
            POWERLINE_BASH_CONTINUATION=1
            POWERLINE_BASH_SELECT=1
            source "$POWERLINESH"
        fi
        ;;
esac

# load the local rc file after the fact
if [ -f "$HOME/.bashrc_local" ]; then
    source "$HOME/.bashrc_local"
fi
