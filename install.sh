#!/bin/sh

BASEDIR=$(dirname "$0")

if [ ! -d ~/.env ]; then
    echo "Copy files into ~/.env"
    mkdir ~/.env
    cp -rp $BASEDIR/* ~/.env/
fi
BASEDIR=~/.env

if [ -f ~/.minttyrc ]; then
    echo "Backup exists file: ~/.minttyrc"
    mv ~/.minttyrc ~/.minttyrc.bak.$(date +%Y%m%d%H%M%S)
fi

if [ ! -L ~/.minttyrc ]; then
    echo "Create link: ~/.minttyrc"
    ln -s $BASEDIR/minttyrc ~/.minttyrc
fi

if [ ! -f ~/.zshrc ]; then
    echo "Create file: ~/.zshrc"
    touch ~/.zshrc
fi

src_cmd="source $(eval echo ~/.env/source_map.sh)"
if ! grep -Fxq "$src_cmd" ~/.zshrc; then
    echo "Add source map in ~/.zshrc"
    echo "$src_cmd" >> ~/.zshrc
fi

echo "Done."
