# dotfiles

WSL 环境配置与常用终端配置文件。

## 文件说明

- `.aliases`：常用命令别名
- `config.fish`：Fish Shell 配置，包含 `proxy` 和 `unproxy` 代理函数
- `.tmux.conf`：tmux 配置
- `.vimrc`：Vim 配置
- `ssh_config`：从 Windows 用户目录复制的 SSH 配置
- `wsl_setup.sh`：WSL 环境初始化脚本
- `copy_config.sh`：将配置文件复制到用户目录，不创建符号链接

## 使用方式

### 复制配置

在 WSL 中执行：

```bash
./copy_config.sh
```

脚本会复制 `.aliases`、`.tmux.conf`、`.vimrc` 和 `config.fish`，并从 Windows 的 `%USERPROFILE%/.ssh/config` 更新 SSH 配置。

### 初始化 WSL 环境

```bash
./wsl_setup.sh
```

脚本会检测已有的 Node.js、uv、Codex 和 pi，已安装的工具会跳过；Node.js 未安装时才会安装 NVM 和 Node.js LTS。

安装的 AI 工具包括：

- OpenAI Codex
- pi coding agent

## 代理命令

在 Fish Shell 中：

```fish
proxy      # 开启 Clash 代理
unproxy    # 关闭代理
```

代理地址会根据 `/etc/resolv.conf` 中的 nameserver 自动获取，HTTP 端口为 `7890`，SOCKS5 端口为 `7891`。
