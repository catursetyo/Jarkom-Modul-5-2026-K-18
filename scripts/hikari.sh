#!/bin/bash
# Soal 2 - Hikari: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.220.4.114
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.220.2.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.220.4.149
    netmask 255.255.255.252

up ip route add default via 192.220.4.113
up ip route add 192.220.3.224/27 via 192.220.4.150
EOF

# eth0 -> Gendou
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.114/30 dev eth0
# eth1 -> Switch-Comm
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.2.1/24 dev eth1
# eth2 -> Kaworu
ip link set eth2 up
ip addr flush dev eth2
ip addr add 192.220.4.149/30 dev eth2

# Soal 3 - routing statis
ip route replace default via 192.220.4.113   # ke atas: Gendou
ip route replace 192.220.3.224/27 via 192.220.4.150   # cabang Kaworu

# Soal 4 - DNS agar node bisa me-resolve nama domain (Seele 8.8.8.8)
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

# Soal 2 - ip forwarding
sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
ip route
