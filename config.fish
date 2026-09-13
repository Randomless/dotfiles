# Clash 代理
function proxy
    set -l host_ip (awk '/nameserver/ {print $2; exit}' /etc/resolv.conf)
    set -l port 7890
    set -gx http_proxy "http://$host_ip:$port"
    set -gx https_proxy "http://$host_ip:$port"
    set -gx ALL_PROXY "socks5://$host_ip:7891"
    # 同时设置大写变量，兼容部分只读取大写变量的工具。
    set -gx HTTP_PROXY $http_proxy
    set -gx HTTPS_PROXY $https_proxy
    echo "代理已开启 -> $host_ip:$port"
end

function unproxy
    set -e http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY
    echo "代理已关闭"
end

if status is-interactive
    and not set -q TMUX
    # 尝试连接名为 0 的会话，如果失败（不存在），则新建一个名为 0 的会话
    tmux attach -t 0; or tmux new -s 0
end
