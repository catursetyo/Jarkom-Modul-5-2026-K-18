#!/bin/bash
# Soal 2 - Yui: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.220.4.110
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.220.3.1
    netmask 255.255.255.128

auto eth2
iface eth2 inet static
    address 192.220.4.137
    netmask 255.255.255.252

auto eth3
iface eth3 inet static
    address 192.220.4.141
    netmask 255.255.255.252

auto eth4
iface eth4 inet static
    address 192.220.4.145
    netmask 255.255.255.252
EOF

# eth0 -> Gendou
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.110/30 dev eth0
# eth1 -> Switch-Hangar
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.3.1/25 dev eth1
# eth2 -> Mari
ip link set eth2 up
ip addr flush dev eth2
ip addr add 192.220.4.137/30 dev eth2
# eth3 -> Rei
ip link set eth3 up
ip addr flush dev eth3
ip addr add 192.220.4.141/30 dev eth3
# eth4 -> Shinji
ip link set eth4 up
ip addr flush dev eth4
ip addr add 192.220.4.145/30 dev eth4

sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
