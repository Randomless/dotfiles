#!/bin/bash

# 使用$PWD获取当前工作目录，替换原来的~/dotfiles
current_dir="$PWD"

ln -s "$current_dir/.aliases" ~/.aliases
ln -s "$current_dir/.zshrc" ~/.zshrc
# ln -s "$current_dir/.p10k.zsh" ~/.p10k.zsh  # 如需取消注释，请去掉这一行前面的 #
ln -s "$current_dir/.tmux.conf" ~/.tmux.conf
ln -s "$current_dir/.vimrc" ~/.vimrc

ln -s "$current_dir/.condarc" ~/.condarc
# cp "$current_dir/.gitconfig" ~/.gitconfig  # 如果需要执行此操作，请取消注释

mkdir -p ~/.pip  # 使用-p选项避免因目录已存在而导致的错误
ln "$current_dir/pip.conf" ~/.pip/pip.conf

# 通常不推荐在脚本中直接source ~/.zshrc，但如果需要此行为，请取消下面的注释
# source ~/.zshrc

echo "脚本执行完成，已使用当前目录下的文件创建符号链接。"