#!/bin/bash

PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <netctl profile>"
    exit 0
fi

set -e
FILE="$1"
if [ ! -f "$FILE" ]; then
    echo "$0: cannot access '$FILE': No such file or directory"
    exit 1
fi

SSID=$(grep "^ESSID=" ${FILE} | head -1 | cut -d "=" -f 2)
PASSWORD=$(grep "^Key=" ${FILE} | head -1 | cut -d "=" -f 2)
if [ -z "$SSID" -o -z "$PASSWORD" ]; then
    echo "$0: error parsing file $FILE"
    exit 1
fi

PAYLOAD="WIFI:S:${SSID};T:WPA;P:${PASSWORD};;"
echo "Generating QR code for SSID:${SSID} and password:${PASSWORD}"
echo "${PAYLOAD}" | qrencode -t utf8
