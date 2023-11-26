#!/bin/bash

### Default route interface detection
HOST_IF=$(ip route | grep default | awk '{print $5}')
if [ -z "$HOST_IF" ]; then
    echo "Host default interface not detected!" >&2
    exit 1
fi
echo "Host default interface on $HOST_IF"

IPLOCAL="$(ip a | grep -v inet6 | grep inet | grep "$HOST_IF" | awk '{ print $2 }')"
if [ -z "$IPLOCAL" ]; then
    echo "Local ip address not detected!" >&2
    exit 1
fi
echo "Host local ip address: $IPLOCAL"

VPN="$(ip r | grep "$HOST_IF" | grep via | grep -v default | awk '{ print $1 }')"
if [ -z "$VPN" ]; then
    echo "VPN ip address not detected!" >&2
    exit 1
fi
echo "VPN ip address: $VPN"

### Root check
if [ "$EUID" -ne 0 ]; then
    echo "This script requires root."
    exit
fi

# Allow established output traffic.
iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# Allow output DNS requests.
# iptables -A OUTPUT -m conntrack --ctstate NEW -p udp -m udp --dport 53 -s "$IPLOCAL" -j ACCEPT
# Allow traffic toward the internal network.
# iptables -A OUTPUT -m conntrack --ctstate NEW -s "$IPLOCAL" -d "$IPLOCAL" -j ACCEPT
# Allow traffic toward the VPN server.
iptables -A OUTPUT -m conntrack --ctstate NEW -s "$IPLOCAL" -d "$VPN" -j ACCEPT
# Deny everything else.
iptables -A OUTPUT -m conntrack --ctstate NEW -s "$IPLOCAL" -j DROP
# Set DNS (disabled, use dnsmasq instead)
# Google DNS
# echo "nameserver 8.8.8.8" > /etc/resolv.conf
# echo "nameserver 8.8.4.4" >> /etc/resolv.conf
# Quad9 DNS
# echo "nameserver 9.9.9.9" > /etc/resolv.conf
# echo "nameserver 149.112.112.112" >> /etc/resolv.conf
