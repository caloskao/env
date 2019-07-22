#!/bin/sh

function __cygwin_cd_windows_path() {
  convertedPath=$(cygpath -u "$1")
  #   echo $convertedPath
  cd "$convertedPath"
}

alias cdw=cd_windows_path
