#!/bin/bash
# Soal 8 - Pen-Pen (192.220.3.194): install iptables + netcat-traditional, listener TCP 80

grep -q '^nameserver' /etc/resolv.conf 2>/dev/null || echo 'nameserver 8.8.8.8' > /etc/resolv.conf

if ! command -v iptables >/dev/null 2>&1 || ! command -v nc.traditional >/dev/null 2>&1; then
  apt-get update
  apt-get install -y iptables netcat-traditional
fi

# Hentikan listener lama jika script dijalankan ulang
[ -f /var/run/svc_80.pid ] && kill "$(cat /var/run/svc_80.pid)" 2>/dev/null || true
pkill -f "nc.traditional -nlvp 80 -q 0" 2>/dev/null || true

# Listener TCP 80: balas "Welcome to {hostname}" lalu tutup koneksi dengan bersih
touch /root/nc_80.log
nohup sh -c 'while true; do printf "Welcome to %s\n" "$(hostname)" | nc.traditional -nlvp 80 -q 0 >> /root/nc_80.log 2>&1; done' </dev/null >/dev/null 2>&1 &
echo $! > /var/run/svc_80.pid

sleep 1
ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || ps aux | grep '[n]c.traditional'
