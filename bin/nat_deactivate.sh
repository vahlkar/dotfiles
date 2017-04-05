#!/bin/bash
IF_ETH=enp3s0

uid=$(id -u)
if [ "$uid" -ne 0 ]; then
    echo "Must be run as root."
    exit 1
fi

echo "Reset firewall settings."
iptables-restore /etc/iptables/iptables.rules

echo "Deactivate IP forward."
echo 0 > /proc/sys/net/ipv4/ip_forward

echo "Stop DHCP Server."
pkill dhcpd

echo "Unconfigure network interface ${IF_ETH}."
ip link set "$IF_ETH" down
ip addr flush "$IF_ETH"

echo "Start netctl-ifplugd@${IF_ETH}.service"
systemctl start "netctl-ifplugd@${IF_ETH}.service"
