#!/bin/bash
# Soal 2 - Rei: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.220.4.142
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.220.0.1
    netmask 255.255.254.0
EOF

# eth0 -> Yui
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.142/30 dev eth0
# eth1 -> Switch-Quarters
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.0.1/23 dev eth1

sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
