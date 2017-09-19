#!/bin/bash

function fail
{
    _message="$@"
    echo "install: $_message" 1>&2
    exit 1
}

function mkclone
{
    local _repo="$1"
    local _path="$2"

    mkdir -p "$_path" || fail "mkdir failed"
    pushd "$_path" || fail "pushd failed"
    git clone "$_repo" "$_path" || fail "git clone failed"
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
        mv "$_config_target" "${_config_target}.backup" || fail "mv failed"
    fi

    echo -n "[+] ... installing $_repo_file..." 1>&2
    ln -s "$_repo_root/$_repo_file" "$_config_target" || fail "ln failed"
    echo "done!" 1>&2
}    

CONFIGS_ROOT="$(readlink -f "$(echo "$0" | sed -e 's/\/install.sh$//')")"
CONFIGS_PROPER="$HOME/local/var/git/local/configs"
    
test -z "$(which git)" && fail "git not installed"
echo "[+] git installed" 1>&2

if [ "$CONFIGS_ROOT" != "$CONFIGS_PROPER" -a ! -d "$CONFIGS_PROPER" ]; then
    echo "[*] Root directory mismatch. Cloning to local." 1>&2
    mkclone "$CONFIGS_ROOT" "$CONFIGS_PROPER" || fail "mkclone failed"
else
    echo "[*] Root directory mismatch. Updating local." 1>&2
    pushd "$CONFIGS_PROPER" || fail "pushd failed"
    git pull origin master || fail "git failed"
    popd
fi

if [ -z "$(which powerline-daemon)" ]; then
    test -z "$(which pip)" && fail "pip not installed"
    
    if [ ! -d "$HOME/local/var/git/github/powerline" ]; then
        mkclone "https://github.com/powerline/powerline.git" "$HOME/local/var/git/github/powerline/powerline" || fail "mkclone failed"
    fi

    pushd "$HOME/local/var/git/github/powerline" || fail "pushd failed"
    pip install --user ./powerline || fail "pip failed"
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
    mkdir -p "$HOME/.config" || fail "mkdir failed"
fi

relink "$CONFIGS_PROPER" "powerline" "$HOME/.config/powerline"

if [ ! -d "$HOME/local/bin" ]; then
    mkdir -p "$HOME/local/bin" || fail "mkdir failed"
fi

relink "$CONFIGS_PROPER" "update.sh" "$HOME/local/bin/update-configs"

echo "[+] configs installed." 1>&2

exit 0
