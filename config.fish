if status is-interactive
    and not set -q TMUX
    # 尝试连接名为 0 的会话，如果失败（不存在），则新建一个名为 0 的会话
    tmux attach -t 0; or tmux new -s 0
end
