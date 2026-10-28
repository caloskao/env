#!/bin/bash
# 在全新的 Ubuntu container（以 root 執行）裡套用整套設定並驗證冪等性。
# 用法：docker run --rm -v "$PWD:/repo:ro" ubuntu:26.04 bash /repo/tests/ci.sh
# snap 相依的模組（gui、hugo）需要 systemd，container 裡無法測，這裡關掉。
set -euo pipefail

REPO=${REPO:-/repo}
TEST_USER=tester

apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq sudo curl git ca-certificates >/dev/null
id "$TEST_USER" >/dev/null 2>&1 || useradd -m -s /bin/bash "$TEST_USER"
echo "$TEST_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$TEST_USER

sudo -u "$TEST_USER" -H REPO="$REPO" bash <<'AS_USER'
set -euo pipefail
cd "$HOME"

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

mkdir -p ~/.local/share
cp -r "$REPO" ~/.local/share/chezmoi
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<'TOML'
[data.modules]
    node = true
    python = true
    rust = true
    tauri = false
    bun = true
    docker = true
    devcli = true
    network = true
    media = true
    gui = false
    hugo = false
TOML

echo "::group::chezmoi init --apply"
chezmoi init --apply --no-tty
echo "::endgroup::"

echo "::group::idempotency"
status=$(chezmoi status)
if [ -n "$status" ]; then
    echo "chezmoi status is not clean after first apply:"; echo "$status"; exit 1
fi
chezmoi apply --no-tty
echo "::endgroup::"

echo "::group::smoke test"
zsh -i -c 'echo "zsh ok: $ZSH_THEME"' 2>&1 | tail -1
for cmd in node npm uv markitdown cargo tldr bun docker gh glab wireproxy ffmpeg warp-cli iperf3 batcat btop lnav git-lfs 7z; do
    zsh -i -c "command -v $cmd" >/dev/null 2>&1 || { echo "missing: $cmd"; exit 1; }
done
if apt-cache show du-dust >/dev/null 2>&1; then
    command -v dust >/dev/null || { echo "missing: dust"; exit 1; }
fi
[ "$(getent passwd "$USER" | cut -d: -f7)" = "$(command -v zsh)" ] || { echo "login shell is not zsh"; exit 1; }
id -nG | grep -qw docker || getent group docker | grep -qw "$USER" || { echo "not in docker group"; exit 1; }
echo "all checks passed"
echo "::endgroup::"
AS_USER
