#!/usr/bin/env bash

if [ -f "${HOME}/.bashrc_exports" ]; then
    source "${HOME}/.bashrc_exports"
fi

if [ -f "${HOME}/.bashrc" ]; then
    source "${HOME}/.bashrc"
fi

if [ -f "${HOME}/.bashrc.local" ]; then
    source "${HOME}/.bashrc.local"
fi
