$sysctl = @"
fs.aio-max-nr=524288
fs.inotify.max_queued_events=1048576
fs.inotify.max_user_instances=1048576
fs.inotify.max_user_watches=1048576
fs.file-max=131072
vm.max_map_count=524288
net.ipv4.tcp_tw_reuse=1
net.ipv4.ip_local_port_range=32768 60999
"@ && wsl -d docker-desktop sh -c "echo '$sysctl' >> /etc/sysctl.conf && sysctl -p"

wsl -d docker-desktop sh -c "sysctl fs.inotify.max_user_instances"
