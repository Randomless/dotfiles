#!/bin/bash

set -e

# 使用脚本所在目录，避免从其他目录调用时找不到配置文件。
current_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

copy_config() {
    local source="$1"
    local target="$2"

    if [ ! -f "$source" ]; then
        echo "❌ 配置文件不存在: $source"
        exit 1
    fi

    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
    echo "✅ 已复制: $source -> $target"
}

# 复制配置文件，不创建符号链接。
copy_config "$current_dir/.aliases" "$HOME/.aliases"
copy_config "$current_dir/.tmux.conf" "$HOME/.tmux.conf"
copy_config "$current_dir/.vimrc" "$HOME/.vimrc"
copy_config "$current_dir/config.fish" "$HOME/.config/fish/config.fish"

# 获取本 WSL 对应 Windows 用户目录中的 SSH 配置。
mkdir -p "$HOME/.ssh"
windows_userprofile=$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')
if [ -z "$windows_userprofile" ] || ! command -v wslpath >/dev/null 2>&1; then
    echo "❌ 无法定位 Windows 用户目录。"
    exit 1
fi

windows_ssh_config="$(wslpath "$windows_userprofile")/.ssh/config"
if [ ! -f "$windows_ssh_config" ]; then
    echo "❌ Windows SSH 配置不存在: $windows_ssh_config"
    exit 1
fi

# 先清空仓库中的 ssh_config，再复制 Windows 配置。
: > "$current_dir/ssh_config"
cp "$windows_ssh_config" "$current_dir/ssh_config"
cp "$current_dir/ssh_config" "$HOME/.ssh/config"
chmod 600 "$current_dir/ssh_config" "$HOME/.ssh/config"
echo "✅ 已从 Windows 复制 SSH 配置到 $current_dir/ssh_config 和 $HOME/.ssh/config"

echo "配置复制完成。"
