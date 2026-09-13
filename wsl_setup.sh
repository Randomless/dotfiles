#!/bin/bash

# --- 准备工作清单 ---
TASKS=(
    "更新 Ubuntu 软件包列表并安装基础工具 (curl, git, fzf, lf)"
    "安装 chsrc (全能换源工具)"
    "安装 uv (Python 包管理器) 并使用 chsrc 换源"
    "检测 Node.js；未安装时通过 NVM 安装 Node.js LTS 并使用 chsrc 换源"
    "安装 Fish Shell、Fisher、nvm.fish 插件"
    "检测并安装 @openai/codex (无需 sudo)"
    "检测并安装 pi 工具"
    "将默认 Shell 切换为 Fish"
)

echo "==========================================="
echo "    WSL 自动化环境深度配置脚本"
echo "==========================================="
echo "准备执行以下任务:"
for i in "${!TASKS[@]}"; do
    echo "    $((i+1)). ${TASKS[$i]}"
done
echo "-------------------------------------------"

read -p "是否确认开始执行? (y/n): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo "操作已取消。"
    exit 1
fi

echo "🚀 开始配置..."

# 1. 基础工具安装
# 等待 Ubuntu 后台 unattended-upgrades 释放 dpkg/apt 锁，避免脚本无限等待。
wait_for_apt_lock() {
    local timeout=300
    local elapsed=0
    while fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock >/dev/null 2>&1; do
        if [ "$elapsed" -ge "$timeout" ]; then
            echo "❌ apt/dpkg 锁等待超时，请稍后重试。"
            return 1
        fi
        echo "⏳ apt 正被后台更新进程占用，等待锁释放... (${elapsed}/${timeout}s)"
        sleep 5
        elapsed=$((elapsed + 5))
    done
}

wait_for_apt_lock
sudo dpkg --configure -a
sudo apt update
wait_for_apt_lock
sudo apt install -y curl git build-essential fzf lf software-properties-common

# 2. 安装 chsrc（已安装则跳过）
if command -v chsrc >/dev/null 2>&1; then
    echo "✅ chsrc 已安装，跳过。"
else
    echo "📦 安装 chsrc..."
    curl -L https://gitee.com/RubyMetric/chsrc/releases/download/pre/chsrc-x64-linux -o chsrc
    chmod +x chsrc
    sudo mv chsrc /usr/local/bin/
fi

# 3. 安装 uv 并换源（已安装则跳过）
if command -v uv >/dev/null 2>&1 || [ -x "$HOME/.local/bin/uv" ]; then
    echo "✅ uv 已安装，跳过。"
else
    echo "🐍 安装 uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
chsrc set python

# 4-5. 已有 Node.js 时不安装 NVM
if command -v node >/dev/null 2>&1; then
    echo "✅ Node.js 已安装 ($(node --version))，跳过 NVM 和 Node.js 安装。"
else
    echo "🌌 安装 NVM..."
    export NVM_DIR="$HOME/.nvm"
    if [ ! -s "$NVM_DIR/nvm.sh" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    echo "🟢 通过 NVM 安装 Node.js LTS..."
    nvm install --lts
fi
command -v node >/dev/null 2>&1 && chsrc set node
chsrc set ubuntu

# 6. 安装 Fish Shell 及 NVM 插件
echo "🐟 配置 Fish 环境..."
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update && sudo apt install -y fish

# 使用 Fish 安装 Fisher 及适配插件
# 重点：安装 jorgebucaran/nvm.fish 以便在 fish 中使用 nvm
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install rafaelrinaldi/pure"
fish -c "fisher install jethrokuan/z"
fish -c "fisher install jorgebucaran/nvm.fish"

# 7. 安装全局工具（已安装则跳过）
if command -v codex >/dev/null 2>&1; then
    echo "✅ Codex 已安装，跳过。"
else
    echo "🤖 安装 OpenAI Codex 工具..."
    npm install -g @openai/codex
fi

if command -v pi >/dev/null 2>&1; then
    echo "✅ pi 已安装，跳过。"
else
    echo "🧠 安装 pi 工具..."
    npm install -g @mariozechner/pi-coding-agent
fi

# 8. 切换默认 Shell 并清理提示
echo "🔄 切换默认 Shell 为 Fish..."
sudo chsh -s $(which fish) $USER
# 在 Fish 配置文件中静默 greeting
mkdir -p ~/.config/fish
echo "set -U fish_greeting" >> ~/.config/fish/config.fish

echo "==========================================="
echo "✅ 配置完成！"
echo "关键点提醒："
echo "1. 请在 PowerShell 中运行 'wsl --shutdown' 重启。"
echo "2. 以后安装全局包请用：npm install -g <package> (永远不要加 sudo)"
echo "3. NVM 现在在 Fish 中也是开箱即用的。"
echo "==========================================="
