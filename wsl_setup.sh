#!/bin/bash

# --- 准备工作清单 ---
TASKS=(
    "更新 Ubuntu 软件包列表并安装基础工具 (curl, git, fzf, lf)"
    "安装 chsrc (全能换源工具)"
    "安装 uv (Python 包管理器) 并使用 chsrc 换源"
    "安装 NVM (Node Version Manager) 替代原生 Node"
    "通过 NVM 安装 Node.js LTS 并使用 chsrc 换源"
    "安装 Fish Shell、Fisher、nvm.fish 插件"
    "使用 nvm 安装 @openai/codex (无需 sudo)"
    "安装 OpenCode.ai 工具"
    "将默认 Shell 切换为 Fish"
)

echo "==========================================="
echo "    WSL 自动化环境深度配置脚本 (NVM 版)"
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
sudo apt update && sudo apt install -y curl git build-essential fzf lf software-properties-common

# 2. 安装 chsrc
echo "📦 安装 chsrc..."
curl -L https://gitee.com/RubyMetric/chsrc/releases/download/pre/chsrc-x64-linux -o chsrc
chmod +x chsrc
sudo mv chsrc /usr/local/bin/

# 3. 安装 uv 并换源
echo "🐍 安装 uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"
chsrc set python

# 4. 安装 NVM (Bash 环境预装)
echo "🌌 安装 NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 5. 通过 NVM 安装 Node 并换源
echo "🟢 通过 NVM 安装 Node.js LTS..."
nvm install --lts
chsrc set node
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

# 7. 安装全局工具 (现在不需要 sudo 了！)
echo "🤖 安装 OpenAI Codex 工具..."
# 在 bash 脚本中调用 fish 来执行安装，确保路径正确
fish -c "nvm install lts > /dev/null; npm install -g @openai/codex; set -U nvm_default_version lts"

# 8. 安装 OpenCode
echo "💻 安装 OpenCode..."
curl -fsSL https://opencode.ai/install | bash

# 9. 切换默认 Shell 并清理提示
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
