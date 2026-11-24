#!/bin/bash
# Soal 7 - Magi-Balthasar (192.220.4.59): install iptables + netcat-traditional, listener TCP 5000 & 5001

grep -q '^nameserver' /etc/resolv.conf 2>/dev/null || echo 'nameserver 8.8.8.8' > /etc/resolv.conf

if ! command -v iptables >/dev/null 2>&1 || ! command -v nc.traditional >/dev/null 2>&1; then
  apt-get update
  apt-get install -y iptables netcat-traditional
fi

# Hentikan listener lama jika script dijalankan ulang
for p in 5000 5001; do
  [ -f "/var/run/magi_${p}.pid" ] && kill "$(cat "/var/run/magi_${p}.pid")" 2>/dev/null || true
  pkill -f "nc.traditional -nlvp ${p}" 2>/dev/null || true
done

# Jalankan listener permanen TCP 5000 dan 5001 di background
for p in 5000 5001; do
  touch "/root/nc_${p}.log"
  nohup sh -c "while true; do nc.traditional -nlvp ${p} </dev/null >> /root/nc_${p}.log 2>&1; done" </dev/null >/dev/null 2>&1 &
  echo $! > "/var/run/magi_${p}.pid"
done

sleep 1
ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || ps aux | grep '[n]c.traditional'
