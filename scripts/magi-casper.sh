#!/bin/bash
# Soal 7 & 11 - Magi-Casper (192.220.4.58): listener TCP 5000 + blokir ping masuk (echo-request)

grep -q '^nameserver' /etc/resolv.conf 2>/dev/null || echo 'nameserver 8.8.8.8' > /etc/resolv.conf

if ! command -v iptables >/dev/null 2>&1 || ! command -v nc.traditional >/dev/null 2>&1; then
  apt-get update
  apt-get install -y iptables netcat-traditional
fi

# Hentikan listener lama jika script dijalankan ulang
[ -f /var/run/magi_5000.pid ] && kill "$(cat /var/run/magi_5000.pid)" 2>/dev/null || true
pkill -f "nc.traditional -nlvp 5000" 2>/dev/null || true

# Jalankan listener permanen di background (log pesan masuk di /root/nc_5000.log)
touch /root/nc_5000.log
nohup sh -c 'while true; do nc.traditional -nlvp 5000 </dev/null >> /root/nc_5000.log 2>&1; done' </dev/null >/dev/null 2>&1 &
echo $! > /var/run/magi_5000.pid

# Soal 11 - Firewall: blokir semua ping masuk (termasuk satu switch), tetap boleh ping keluar & TCP 5000 hidup
iptables -P INPUT ACCEPT
iptables -F INPUT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

sleep 1
ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || ps aux | grep '[n]c.traditional'
iptables -S INPUT
