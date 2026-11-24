#!/bin/bash
# Soal 2-4 - Yui: IP interface, routing statis, DNS, dan IP forwarding

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

up ip route add default via 192.220.4.109
up ip route add 192.220.4.32/28 via 192.220.4.138
up ip route add 192.220.0.0/23 via 192.220.4.142
up ip route add 192.220.4.0/27 via 192.220.4.146
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

# Soal 3 - routing statis
ip route replace default via 192.220.4.109   # ke atas: Gendou
ip route replace 192.220.4.32/28 via 192.220.4.138   # cabang Mari
ip route replace 192.220.0.0/23 via 192.220.4.142   # cabang Rei
ip route replace 192.220.4.0/27 via 192.220.4.146   # cabang Shinji

# Soal 4 - DNS agar node bisa me-resolve nama domain (Seele 8.8.8.8)
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

# Soal 2 - ip forwarding
sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
ip route
