#!/bin/sh

sudo apt update && sudo apt install -y zsh;
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="risto"/' ~/.zshrc;
sed -i 's/plugins=(git)/plugins=(git zsh_reload)/' ~/.zshrc;
echo 'export TERM=xterm' >> ~/.zshrc;
echo 'HIST_STAMPS="yyyy-mm-dd"' >> ~/.zshrc;
git clone https://github.com/caloskao/env ~/.env;
cat ~/.env/lib-inst/*.sh | sh;
source ~/.zshrc;
