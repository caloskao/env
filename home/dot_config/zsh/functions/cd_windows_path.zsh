# 直接 cd 到 Windows 路徑，例如：cdw 'C:\Users\calos\Downloads'

function __wsl_cd_windows_path() {
  cd "$(wslpath "$1")"
}

alias cdw=__wsl_cd_windows_path
