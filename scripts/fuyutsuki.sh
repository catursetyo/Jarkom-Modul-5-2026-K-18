#!/bin/bash
# Soal 2 - Fuyutsuki: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.220.4.134
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.220.4.57
    netmask 255.255.255.248

auto eth2
iface eth2 inet static
    address 192.220.4.165
    netmask 255.255.255.252

auto eth3
iface eth3 inet static
    address 192.220.4.169
    netmask 255.255.255.252

up ip route add default via 192.220.4.133
up ip route add 192.220.3.192/27 via 192.220.4.166
up ip route add 192.220.4.72/29 via 192.220.4.170
EOF

# eth0 -> Gendou
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.134/30 dev eth0
# eth1 -> Switch-Terminal
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.4.57/29 dev eth1
# eth2 -> Maya
ip link set eth2 up
ip addr flush dev eth2
ip addr add 192.220.4.165/30 dev eth2
# eth3 -> Toji
ip link set eth3 up
ip addr flush dev eth3
ip addr add 192.220.4.169/30 dev eth3

# Soal 3 - routing statis
ip route replace default via 192.220.4.133   # ke atas: Gendou
ip route replace 192.220.3.192/27 via 192.220.4.166   # cabang Maya
ip route replace 192.220.4.72/29 via 192.220.4.170   # cabang Toji

# Soal 2 - ip forwarding
sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
ip route
