#!/bin/sh

function __zsh_set_term_title() {
    DISABLE_AUTO_TITLE=true
    title $1
}

alias zsh-set-term-title=__zsh_set_term_title
alias set-term-title=__zsh_set_term_title

# if [ ! type set-term-title ] then
#     alias set-term-title="__zsh_set_term_title"
# fi