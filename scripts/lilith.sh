#!/bin/bash
# Soal 3 - Lilith: IP + gateway sementara (permanen di soal 6)

ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.4.74/29 dev eth0
ip route replace default via 192.220.4.73

ip -br a
ip route
