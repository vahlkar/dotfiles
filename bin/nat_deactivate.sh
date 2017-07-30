#!/bin/bash
IF_ETH=enp3s0

### Root check
if [ "$EUID" -ne 0 ]; then
    echo "This script requires root."
    exit
fi

echo "Reset firewall settings."
systemctl restart iptables.service

echo "Deactivate IP forward."
echo 0 > /proc/sys/net/ipv4/ip_forward

echo "Stop DHCP Server."
pkill dhcpd

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

echo "Unconfigure network interface ${IF_ETH}."
ip link set "$IF_ETH" down
ip addr flush "$IF_ETH"

echo "Start netctl-ifplugd@${IF_ETH}.service"
systemctl start "netctl-ifplugd@${IF_ETH}.service"
