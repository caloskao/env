# caloskao/env

個人 WSL Ubuntu 開發環境，用 [chezmoi](https://www.chezmoi.io/) 管理。

> v1（純 shell 安裝腳本）保留在 tag [`v1`](https://github.com/caloskao/env/tree/v1)。

## 安裝

在新的 WSL Ubuntu（≥ 24.04）上執行：

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply caloskao/env
```

安裝時會逐一詢問要啟用哪些模組。全部完成後會印出[手動步驟清單](docs/post-install.md)，包括 SSH key、CLI 登入、機密設定檔等。

## 模組

| 模組 | 內容 | 預設 |
|---|---|---|
| core | zsh、oh-my-zsh、powerlevel10k、aliases/functions、git、amix vimrc、`/etc/wsl.conf`、ssh config、常用 CLI（jq、bat、dust、btop、lnav、7zip…） | 必裝 |
| node | nvm + Node LTS | ✅ |
| python | uv + Python + markitdown | ✅ |
| rust | rustup、cargo-binstall、tlrc（tauri-cli 另外詢問） | |
| bun | bun | |
| docker | docker-ce、compose、buildx、docker group | ✅ |
| devcli | gh、glab | ✅ |
| network | cloudflare-warp、wireproxy（[wireproxyctl](https://github.com/caloskao/wireproxyctl)）、iperf3 | |
| media | ffmpeg | |
| gui | chromium、xvfb、CJK 字型 | |
| hugo | hugo + zsh completion | |

要改模組選擇，執行 `chezmoi init --prompt && chezmoi apply`。

## 日常使用

| 指令 | 用途 |
|---|---|
| `chezmoi update` | 拉取 repo 最新版並套用 |
| `chezmoi diff` | 預覽 repo 和本機的差異 |
| `chezmoi edit ~/.zshrc` | 修改受管理的檔案 |
| `chezmoi cd` | 進入 source repo |

- 本機專屬的 shell 設定寫在 `~/.zshrc.local`，不進 repo。
- 個別 SSH Host 放在 `~/.ssh/config.d/`，不進 repo。
- 套件只在清單變動時重新安裝，平常的 `chezmoi apply` 不會升級系統。

## 目錄結構

```
home/                     chezmoi source（.chezmoiroot）
├── .chezmoi.toml.tmpl    模組選擇的 prompt
├── .chezmoidata/         各模組的 apt / snap 套件清單
├── .chezmoiexternal.toml oh-my-zsh、powerlevel10k、amix vimrc
├── .chezmoiscripts/      安裝腳本（before：core；after：各模組）
├── dot_zshrc.tmpl        依模組產生的 .zshrc
└── private_dot_config/zsh/  aliases、functions（private_：目錄權限 0700）
docs/post-install.md      安裝後的手動步驟
tests/ci.sh               在全新 Ubuntu container 裡做 end-to-end 測試
```

## 測試

```sh
docker run --rm -v "$PWD:/repo:ro" ubuntu:26.04 bash /repo/tests/ci.sh
```

container 裡沒有 systemd 和 snapd，所以 `gui`、`hugo` 模組、`/etc/wsl.conf` 只能在真正的 WSL distro 上驗證：

```powershell
wsl --install Ubuntu-26.04 --name env-test
# 測完後
wsl --unregister env-test
```
