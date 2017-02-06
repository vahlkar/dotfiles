#!/bin/bash
IF_ETH=enp1s0
IF_WLAN=wlp2s0
IF_VPN=tun0

SUBNET="10.0.0.0/24"
ROUTER="10.0.0.1/24"

IF_OUT="$IF_WLAN"

uid=$(id -u)
if [ "$uid" -ne 0 ]; then
    echo "Must be run as root."
    exit 1
fi

echo "Stop netctl-ifplugd@${IF_ETH}.service"
systemctl stop "netctl-ifplugd@${IF_ETH}.service"

echo "Configure network interface ${IF_ETH}."
ip link set "$IF_ETH" down
ip addr flush "$IF_ETH"
ip link set "$IF_ETH" up
ip addr add "$ROUTER" dev "$IF_ETH"

echo "Activate IP forward."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "Reset firewall settings."
iptables-restore /etc/iptables/iptables.rules

echo "Allow forward from $SUBNET network."
iptables -A FORWARD -s "$SUBNET" -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

echo "NAT traffic from subnet $SUBNET to interface $IF_OUT."
iptables -t nat -A POSTROUTING -s "$SUBNET" -o "$IF_OUT" -j MASQUERADE

echo "Activate DHCP Server."
dhcpd -cf "/home/volodia/.config/dhcpd/dhcpd.conf" "$IF_ETH"
