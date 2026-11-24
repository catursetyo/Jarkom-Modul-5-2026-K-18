#!/bin/bash
# Soal 12 - Perbaikan sabotase hardening firewall di Magi-Casper (script terpisah)
# Tujuan hardening tetap dipertahankan: policy INPUT = DROP, hanya traffic sah yang diizinkan.

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F INPUT
iptables -F OUTPUT

# 1. Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT
# 2. Izinkan balasan koneksi keluar (ping 8.8.8.8, DNS, apt-get update)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# 3. Izinkan layanan MAGI Casper (TCP 5000)
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT

# Kunci policy INPUT tetap DROP (ping masuk & port lain otomatis ditolak)
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT

echo "=== iptables -S (Magi-Casper) ==="
iptables -S
