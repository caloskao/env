#!/bin/bash

function __wsl_cd_windows_path() {
  target=$(wslpath "$1")
  cd "$target"
}

alias cdw=__wsl_cd_windows_path
