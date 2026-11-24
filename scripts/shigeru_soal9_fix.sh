#!/bin/bash
# Soal 9 - Perbaikan sabotase routing di Shigeru (script terpisah, tidak mengubah shigeru.sh)

# 1. Aktifkan kembali IP forwarding
sysctl -w net.ipv4.ip_forward=1

# 2. Hapus Policy-Based Routing (PBR) yang menjebak trafik eth1 ke table 100
ip rule del iif eth1 lookup 100 priority 90 2>/dev/null || true
ip route flush table 100 2>/dev/null || true

# 3. Hapus rute blackhole menuju subnet Switch-Dogma (192.220.4.72/29)
ip route del blackhole 192.220.4.72/29 2>/dev/null || true

# 4. Kembalikan default route ke Gendou (192.220.4.129 via eth0), bukan Makoto
ip route replace default via 192.220.4.129 dev eth0

# Verifikasi kondisi Shigeru setelah perbaikan
echo "=== ip_forward ==="
cat /proc/sys/net/ipv4/ip_forward
echo "=== ip rule ==="
ip rule show
echo "=== table 100 ==="
ip route show table 100
echo "=== ip route (main) ==="
ip route
