#!/bin/bash

CONFIGS="$HOME/local/var/git/local/configs"

if [ ! -d "$CONFIGS" ]; then
    echo "update: no configs" 1>&2
    exit 1
fi

echo "[+] Updating configs"

pushd "$CONFIGS"
git pull origin master

if [ "$?" != "0" ]; then
    echo "update: git failed" 1>&2
    exit 1
fi

popd

echo "[+] Repository updated. Running installer."

"$CONFIGS/install.sh" || echo "update: installer failed" 1>&2 && exit 1

echo "[+] Configs updated."

exit 0
