#!/bin/bash
# Soal 2 - Kaji: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.220.4.122
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.220.4.101
    netmask 255.255.255.252
EOF

# eth0 -> Gendou
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.122/30 dev eth0
# eth1 -> Switch-Intel
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.4.101/30 dev eth1

sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
