#!/bin/bash
sudo iptables -A TCP -p tcp -m tcp --dport 139 -j ACCEPT
sudo iptables -A TCP -p tcp -m tcp --dport 445 -j ACCEPT
sudo iptables -A UDP -p udp -m udp --dport 137:138 -j ACCEPT
