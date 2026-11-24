#!/bin/bash
# Soal 2 - Makoto: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.220.4.162
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 192.220.4.89
    netmask 255.255.255.248

up ip route add default via 192.220.4.161
EOF

# eth0 -> Shigeru
ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.162/30 dev eth0
# eth1 -> Switch-Radar
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.4.89/29 dev eth1

# Soal 3 - routing statis
ip route replace default via 192.220.4.161   # ke atas: Shigeru

# Soal 4 - DNS agar node bisa me-resolve nama domain (Seele 8.8.8.8)
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

# Soal 2 - ip forwarding
sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
ip route
