#!/bin/bash
# 把登入 shell 改成 zsh
set -euo pipefail

zsh_path=$(command -v zsh)
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
    sudo chsh -s "$zsh_path" "$USER"
fi
