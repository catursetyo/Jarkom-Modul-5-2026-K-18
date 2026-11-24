#!/bin/bash
# Soal 3 - Sachiel: IP + gateway sementara (permanen di soal 6)

ip link set eth0 up
ip addr flush dev eth0
ip addr add 192.220.3.130/26 dev eth0
ip route replace default via 192.220.3.129

ip -br a
ip route
