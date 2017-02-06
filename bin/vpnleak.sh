#!/bin/bash
IF_OUT=wlp2s0
VPN=147.127.192.10
IPLOCAL="$(ip a | grep -v inet6 | grep inet | grep "$IF_OUT" | awk '{ print $2 }')"

# Allow established output traffic.
iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# Allow output DNS requests.
iptables -A OUTPUT -m conntrack --ctstate NEW -p udp -m udp --dport 53 -s "$IPLOCAL" -j ACCEPT
# Allow traffic toward the VPN server.
iptables -A OUTPUT -m conntrack --ctstate NEW -s "$IPLOCAL" -d "$VPN" -j ACCEPT
# Deny everything else.
iptables -A OUTPUT -m conntrack --ctstate NEW -s "$IPLOCAL" -j DROP
