#!/bin/bash

CONFIGS="$HOME/local/var/git/local/configs"

if [ ! -d "$CONFIGS" ]; then
    echo "update: no configs" 1>&2
    exit 1
fi

echo "[+] updating configs" 1>&2

pushd "$CONFIGS"
git pull origin master || ( echo "update: git failed" 1>&2 && exit 1 )

if [ "$?" != "0" ]; then
    echo "update: git failed" 1>&2
    exit 1
fi

popd

echo "[+] repository updated. running installer." 1>&2

"$CONFIGS/install.sh" || ( echo "update: installer failed" 1>&2 && exit 1 )

echo "[+] configs updated." 1>&2

exit 0
