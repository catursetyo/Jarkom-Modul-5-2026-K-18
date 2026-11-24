#!/bin/bash
# Soal 10 - Perbaikan sabotase NAT di Gendou (script terpisah, tidak mengubah gendou.sh)

# Hapus rule RETURN yang melewati MASQUERADE untuk Switch-Cage (192.220.4.64/29)
iptables -t nat -D POSTROUTING -s 192.220.4.64/29 -o eth0 -j RETURN 2>/dev/null || true

# Pastikan rule MASQUERADE dari Soal 4 tetap aktif
iptables -t nat -C POSTROUTING -s 192.220.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
  iptables -t nat -A POSTROUTING -s 192.220.0.0/16 -o eth0 -j MASQUERADE

# Verifikasi tabel NAT Gendou
echo "=== iptables -t nat -S (Gendou) ==="
iptables -t nat -S
echo "=== iptables -t nat -L POSTROUTING -n -v (Gendou) ==="
iptables -t nat -L POSTROUTING -n -v
