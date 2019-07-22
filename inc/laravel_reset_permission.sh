#!/bin/sh

function __laravel_reset_permission() {
  list=$(find app bootstrap config database public resources routes storage tests -type f -perm -o+x)
  list=$list" "$(find . -maxdepth 1 -type f -perm -o+x)
  if [ $list != " " ]
  then
    echo "Set file mode to 644:\n"$list"\n"
    echo $list | xargs chmod 644
  else
    echo "Nothing to reset permission.\n"
  fi
}

alias laravel_reset_permission=__laravel_reset_permission
alias lrp=__laravel_reset_permission