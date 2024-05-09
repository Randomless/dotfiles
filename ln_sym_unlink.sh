#!/bin/bash

# 移除之前创建的符号链接
unlink ~/.aliases
unlink ~/.zshrc
# unlink ~/.p10k.zsh  # 注释掉的操作也建议取消，如果已执行则解开注释
unlink ~/.tmux.conf
unlink ~/.vimrc
unlink ~/.condarc
# 不直接移除.gitconfig，因为可能是cp操作，应检查并手动处理如有必要
# unlink ~/.gitconfig

# 如果存在，删除.pip目录和其中的pip.conf链接
if [ -d ~/.pip ]; then
    rm -rf ~/.pip
fi

# 还原文件权限，这里假设是取消之前的777权限设置