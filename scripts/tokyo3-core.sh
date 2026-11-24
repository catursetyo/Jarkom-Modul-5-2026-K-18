#!/bin/bash
# Soal 8 - Tokyo3-Core (192.220.4.106): install iptables + netcat-traditional, listener TCP 80 & 8080

grep -q '^nameserver' /etc/resolv.conf 2>/dev/null || echo 'nameserver 8.8.8.8' > /etc/resolv.conf

if ! command -v iptables >/dev/null 2>&1 || ! command -v nc.traditional >/dev/null 2>&1; then
  apt-get update
  apt-get install -y iptables netcat-traditional
fi

# Hentikan listener lama jika script dijalankan ulang
for p in 80 8080; do
  [ -f "/var/run/svc_${p}.pid" ] && kill "$(cat "/var/run/svc_${p}.pid")" 2>/dev/null || true
  pkill -f "nc.traditional -nlvp ${p} -q 0" 2>/dev/null || true
done

# Listener TCP 80: balas "Welcome to {hostname}"
touch /root/nc_80.log
nohup sh -c 'while true; do printf "Welcome to %s\n" "$(hostname)" | nc.traditional -nlvp 80 -q 0 >> /root/nc_80.log 2>&1; done' </dev/null >/dev/null 2>&1 &
echo $! > /var/run/svc_80.pid

# Listener TCP 8080: balas "syifa imutz"
touch /root/nc_8080.log
nohup sh -c 'while true; do printf "syifa imutz\n" | nc.traditional -nlvp 8080 -q 0 >> /root/nc_8080.log 2>&1; done' </dev/null >/dev/null 2>&1 &
echo $! > /var/run/svc_8080.pid

sleep 1
ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || ps aux | grep '[n]c.traditional'
