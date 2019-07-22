#!env zsh

BASEDIR=$(dirname "$0")

if [ ! -d $HOME/.env ]; then
    echo "Copy files into $HOME/.env"
    mkdir $HOME/.env
    cp -rp $BASEDIR/* $HOME/.env/
fi
BASEDIR=$HOME/.env

if [ -f $HOME/.minttyrc ]; then
    echo "Backup exists file: $HOME/.minttyrc"
    mv $HOME/.minttyrc $HOME/.minttyrc.bak.$(date +%Y%m%d%H%M%S)
fi

if [ ! -L $HOME/.minttyrc ]; then
    echo "Create link: $HOME/.minttyrc"
    ln -s $BASEDIR/minttyrc $HOME/.minttyrc
fi

if [ ! -f $HOME/.zshrc ]; then
    echo "Create file: $HOME/.zshrc"
    touch $HOME/.zshrc
fi

src_cmd="source $(eval echo $HOME/.env/source_map.sh)"
if ! grep -Fxq "$src_cmd" $HOME/.zshrc; then
    echo "Add source map in $HOME/.zshrc"
    echo "$src_cmd" >> $HOME/.zshrc
fi

printf "Reloading $HOME/.zshrc ... "

source $HOME/.zshrc

echo "Done."
