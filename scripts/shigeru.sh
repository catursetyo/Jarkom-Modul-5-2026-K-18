#!/bin/bash
# Soal 2 - Shigeru: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.220.4.130
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.220.4.81
    netmask 255.255.255.248

auto eth2
iface eth2 inet static
    address 192.220.4.161
    netmask 255.255.255.252
EOF

# eth0 -> Gendou
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.130/30 dev eth0
# eth1 -> Switch-Monolith
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.4.81/29 dev eth1
# eth2 -> Makoto
ip link set eth2 up
ip addr flush dev eth2
ip addr add 192.220.4.161/30 dev eth2

sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
