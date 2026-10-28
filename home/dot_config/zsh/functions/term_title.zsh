# 固定 terminal 標題，避免被 oh-my-zsh 自動覆寫

function __zsh_set_term_title() {
  DISABLE_AUTO_TITLE=true
  title $1
}

function __zsh_reset_term_title() {
  DISABLE_AUTO_TITLE=false
}

alias zsh-set-term-title=__zsh_set_term_title
alias set-term-title=__zsh_set_term_title
alias zsh-reset-term-title=__zsh_reset_term_title
alias reset-term-title=__zsh_reset_term_title
