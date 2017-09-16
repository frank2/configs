# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ]; then
  source "${HOME}/.bashrc"
fi

# load the local rc file after the fact
if [ -f "${HOME}/.bash_profile.local" ]; then
    source "${HOME}/.bash_profile.local"
fi
