#!/bin/bash
# Soal 2 - Gendou: IP interface + IP forwarding (tanpa apt, internet belum ada)

cat <<'EOF' > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.220.4.109
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 192.220.4.113
    netmask 255.255.255.252

auto eth3
iface eth3 inet static
    address 192.220.4.117
    netmask 255.255.255.252

auto eth4
iface eth4 inet static
    address 192.220.4.121
    netmask 255.255.255.252

auto eth5
iface eth5 inet static
    address 192.220.4.125
    netmask 255.255.255.252

auto eth6
iface eth6 inet static
    address 192.220.4.129
    netmask 255.255.255.252

auto eth7
iface eth7 inet static
    address 192.220.4.133
    netmask 255.255.255.252

auto eth8
iface eth8 inet static
    address 192.220.4.105
    netmask 255.255.255.252
EOF

# eth1 -> Yui
ip link set eth1 up
ip addr flush dev eth1
ip addr add 192.220.4.109/30 dev eth1
# eth2 -> Hikari
ip link set eth2 up
ip addr flush dev eth2
ip addr add 192.220.4.113/30 dev eth2
# eth3 -> Asuka
ip link set eth3 up
ip addr flush dev eth3
ip addr add 192.220.4.117/30 dev eth3
# eth4 -> Kaji
ip link set eth4 up
ip addr flush dev eth4
ip addr add 192.220.4.121/30 dev eth4
# eth5 -> Misato
ip link set eth5 up
ip addr flush dev eth5
ip addr add 192.220.4.125/30 dev eth5
# eth6 -> Shigeru
ip link set eth6 up
ip addr flush dev eth6
ip addr add 192.220.4.129/30 dev eth6
# eth7 -> Fuyutsuki
ip link set eth7 up
ip addr flush dev eth7
ip addr add 192.220.4.133/30 dev eth7
# eth8 -> Switch-Cmd
ip link set eth8 up
ip addr flush dev eth8
ip addr add 192.220.4.105/30 dev eth8

# eth0 -> NAT1 (DHCP). udhcpc milik GNS3 tidak punya script bawaan, jadi dibuatkan handler.
cat <<'EOF' > /root/udhcpc.script
#!/bin/sh
case "$1" in
  bound|renew)
    ip addr flush dev "$interface"
    ip addr add "$ip/$mask" dev "$interface"
    [ -n "$router" ] && ip route replace default via "${router%% *}" dev "$interface"
    [ -n "$dns" ] && for d in $dns; do echo "nameserver $d"; done > /etc/resolv.conf
    ;;
esac
EOF
chmod +x /root/udhcpc.script
ip link set eth0 up
if command -v dhclient >/dev/null; then dhclient eth0
elif command -v udhcpc >/dev/null; then udhcpc -i eth0 -n -q -s /root/udhcpc.script
elif [ -x /gns3/bin/busybox ]; then /gns3/bin/busybox udhcpc -i eth0 -n -q -s /root/udhcpc.script
else ifup eth0; fi

sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf 2>/dev/null || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

ip -br a
