#!/bin/bash

SUBNET="10.0.0.0/24"
ROUTER="10.0.0.1/24"

### Default route interface detection
IF_HOST=$(ip route | grep default | awk '{print $5}')
if [ -z "$IF_HOST" ]; then
    echo "Host default interface not detected!" >&2
    exit 1
fi
echo "Host default interface on $IF_HOST"
IF_OUT="$IF_HOST"

IF_ETH="$(ip l | grep -B1 "link/ether" | grep "^[0-9]:" | grep -v "$IF_HOST" | awk '{ print $2 }' | sed -e 's/://')"
if [ -z "$IF_ETH" ]; then
    echo "Shared interface not detected!" >&2
    exit 1
fi
echo "Ethernet interface on $IF_ETH"

IF_VPN="$(ip l | grep -B1 "link/none" | grep "^[0-9]:" | awk '{ print $2 }' | sed -e 's/://')"
if [ -z "$IF_VPN" ]; then
    echo "No VPN"
    IF_OUT="$IF_HOST"
else
    echo "VPN detected on interface $IF_VPN"
    IF_OUT="$IF_VPN"
fi

### Root check
if [ "$EUID" -ne 0 ]; then
    echo "This script requires root."
    exit
fi

ifplugd_active="$(systemctl status | grep -v grep | grep "netctl-ifplugd@${IF_ETH}.service")"
if [ ! -z "$ifplugd_active" ]; then
    echo "Stop netctl-ifplugd@${IF_ETH}.service"
    systemctl stop "netctl-ifplugd@${IF_ETH}.service"
fi

echo "Configure network interface ${IF_ETH}."
ip link set "$IF_ETH" down
ip addr flush "$IF_ETH"
ip link set "$IF_ETH" up
ip addr add "$ROUTER" dev "$IF_ETH"

echo "Activate IP forward."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "Reset firewall settings."
systemctl restart iptables.service

echo "Allow forward from $SUBNET network."
iptables -A FORWARD -s "$SUBNET" -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

echo "NAT traffic from subnet $SUBNET to interface $IF_OUT."
iptables -t nat -A POSTROUTING -s "$SUBNET" -o "$IF_OUT" -j MASQUERADE

echo "Activate DHCP Server."
dhcpd -cf "/home/volodia/.config/dhcpd/dhcpd.conf" "$IF_ETH"
