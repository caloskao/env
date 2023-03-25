#!/bin/sh

echo "##### Begin install caloskao/env #####"

sudo apt update && sudo apt install -y zsh;

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended;

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k;

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ${ZSH_CUSTOM:-$HOME/.zshrc};

# echo 'export TERM=xterm' >> ~/.zshrc;

echo 'HIST_STAMPS="yyyy-mm-dd"' >> $HOME/.zshrc;

git clone https://github.com/caloskao/env $HOME/.env;

cat $HOME/.env/lib-inst/*.sh | sh;

zsh -c "source $HOME/.zshrc";

echo "##### Installation completed! Enjoy! #####";
