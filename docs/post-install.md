# 安裝後手動步驟

`chezmoi init --apply` 跑完後，以下步驟需要手動完成。機密不進 repo，所以這些步驟無法自動化。
之後想再看一次，執行 `cat "$(chezmoi source-path)/../docs/post-install.md"`。

## 1. 套用 WSL / 登入 shell 設定

- 在 Windows 端執行 `wsl --shutdown`，再重新開啟 terminal。重啟後 `/etc/wsl.conf`（systemd）、登入 shell 改成 zsh、docker group 才會生效。
- 如果先前因為 snapd 還沒啟動而失敗，重啟後再執行一次 `chezmoi apply`。

## 2. SSH key（每台機器各自一把）

```sh
ssh-keygen -t ed25519 -C "calos@$(hostname)"
cat ~/.ssh/id_ed25519.pub
```

把公鑰登錄到以下地方：

- GitHub：<https://github.com/settings/keys>
- GitLab
- 要連線的伺服器（`ssh-copy-id`，或從舊機器把公鑰加進 `authorized_keys`）

## 3. SSH Host 設定

從舊機器把 `~/.ssh/config.d/` 下的檔案複製過來，例如 OCI 主機的設定。
`~/.ssh/config` 由 chezmoi 管理，只負責 `Include config.d/*` 和 `Host *` 的預設值。

## 4. CLI 登入（devcli 模組）

```sh
gh auth login
glab auth login
```

## 5. 網路工具（network 模組）

- wireproxy 由 [wireproxyctl](https://github.com/caloskao/wireproxyctl) 管理。沒有 systemd 的環境 apply 時會略過，啟用 systemd 後補跑 `sudo wireproxyctl install`
- 用 VPN 供應商的 WireGuard 設定建立 profile：`sudo wireproxyctl add <name> --from <wg.conf>`；`wireproxyctl list` 查看狀態
- 舊機器的 profile（`/etc/wireproxy/*.conf` + `wg-conf/`）可以直接複製過來繼續用，權限維持 `600`，然後 `sudo systemctl enable --now wireproxy@<name>`
- Cloudflare WARP：`warp-cli registration new`

## 6. Windows 端

- 安裝 MesloLGS NF 字型（powerlevel10k 需要）：<https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k>
- Windows Terminal：Ubuntu profile 的字型改成 `MesloLGS NF`。v1 的完整設定可以參考 `git show v1:ext/windows-terminal.json`。

## 7. （可選）搬移 zsh history

```sh
# 在舊機器上
scp ~/.zsh_history <new-host>:~/.zsh_history
```
