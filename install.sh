#!/bin/bash
    
if [ -z "$(which git)" ]; then
    echo "configs: git not installed" 1>&2
    exit 1
else
    echo "[+] git installed" 1>&2
fi

function mkclone
{
    local _repo="$1"
    local _path="$2"

    mkdir -p "$_path"

    if [ "$?" != "0" ]; then
        echo "configs: mkdir failed" 1>&2
        exit 1
    fi
        
    pushd "$_path"

    if [ "$?" != "0" ]; then
        echo "configs: pushd failed" 1>&2
        exit 1
    fi
    
    git clone "$_repo" "$_path"
        
    if [ "$?" != "0" ]; then
        echo "configs: git failed" 1>&2
        exit 1
    fi

    popd
}

function relink
{
    local _repo_root="$1"
    local _repo_file="$2"
    local _config_target="$3"

    if [ -z "$_config_target" ]; then
        _config_target="$HOME/$_repo_file"
    fi

    if [ -e "$_config_target" ]; then
        mv "$_config_target" "${_config_target}.backup"
        
        if [ "$?" != "0" ]; then
            echo "configs: mv failed" 1>&2
            exit 1
        fi
    fi

    echo -n "[+] ... installing $_repo_file..."
    ln -s "$_repo_root/$_repo_file" "$_config_target"
       
    if [ "$?" != "0" ]; then
        echo "configs: ln failed" 1>&2
        exit 1
    fi

    echo "done!"
}    

CONFIGS_ROOT="$(readlink -f "$(echo "$0" | sed -e 's/\/install.sh$//')")"
CONFIGS_PROPER="$HOME/local/var/git/local/configs"

if [ "$CONFIGS_ROOT" != "$CONFIGS_PROPER" -a ! -d "$CONFIGS_PROPER" ]; then
    echo "[*] Root directory mismatch. Cloning to local."
    mkclone "$CONFIGS_ROOT" "$CONFIGS_PROPER"
else
    echo "[*] Root directory mismatch. Updating local."
    pushd "$CONFIGS_PROPER"
    git pull origin master

    if [ "$?" != "0" ]; then
        echo "configs: git failed" 1>&2
        exit 1
    fi
    popd
fi

if [ -z "$(which powerline-daemon)" ]; then
    if [ -z "$(which pip)" ]; then
        echo "configs: pip not installed" 1>&2
        exit 1
    fi
    
    if [ ! -d "$HOME/local/var/git/github/powerline" ]; then
        mkclone "https://github.com/powerline/powerline.git" "$HOME/local/var/git/github/powerline/powerline"
    fi

    pushd "$HOME/local/var/git/github/powerline"

    if [ "$?" != "0" ]; then
        echo "configs: pushd failed" 1>&2
        exit 1
    fi
    
    pip install --user ./powerline
        
    if [ "$?" != "0" ]; then
        echo "configs: pip failed" 1>&2
        exit 1
    fi
    
    popd
    
    echo "[+] successfully installed powerline" 1>&2
else
    echo "[+] powerline installed" 1>&2
fi

echo "[+] replacing configs" 1>&2

relink "$CONFIGS_PROPER" ".bashrc"
relink "$CONFIGS_PROPER" ".bash_profile"
relink "$CONFIGS_PROPER" ".emacs.d"
relink "$CONFIGS_PROPER" ".minttyrc"
relink "$CONFIGS_PROPER" ".tmux.conf"

if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"

    if [ "$?" != "0" ]; then
        echo "configs: mkdir failed" 1>&2
        exit 1
    fi
fi

relink "$CONFIGS_PROPER" "powerline" "$HOME/.config/powerline"
