#!/bin/bash
# Soal 3 - Comm-Net: IP + gateway sementara (permanen di soal 6)

ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.2.2/24 dev eth0
ip route replace default via 192.220.2.1

# Soal 4 - DNS
echo 'nameserver 8.8.8.8' > /etc/resolv.conf

ip -br a
ip route
