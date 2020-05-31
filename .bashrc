#!/usr/bin/env bash

if [ -f "${HOME}/.bashrc_exports" ]; then
    source "${HOME}/.bashrc_exports"
fi

if [ -f "${HOME}/.bash_profile" ]; then
    source "${HOME}/.bash_profile"
fi

if [ -f "${HOME}/.bashrc.local" ]; then
    source "${HOME}/.bashrc.local"
fi
