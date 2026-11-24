#!/bin/bash
# Soal 10 - Perbaikan sabotase NAT di Misato (script terpisah, tidak mengubah misato.sh)

# Hapus rule SNAT palsu (172.31.99.1) untuk Switch-Cage (192.220.4.64/29)
iptables -t nat -D POSTROUTING -s 192.220.4.64/29 ! -d 192.220.0.0/16 -o eth0 -j SNAT --to-source 172.31.99.1 2>/dev/null || true

# Verifikasi tabel NAT Misato sudah bersih
echo "=== iptables -t nat -S (Misato) ==="
iptables -t nat -S
