#!/bin/bash

# set -e

IFIN="wlo1"
# LOGFILE="/tmp/debug"

log () {
    # echo "[$(date +'%Y-%m-%d %T')] $@" >> "$LOGFILE"
    echo "$@" | systemd-cat
}

IFEXT="$1"
INTERFACES="$(iw dev | grep Interface | sed -e 's/Interface//' | sed -e 's/\s*//g')"
CHECK="$(echo "$INTERFACES" | grep "$IFEXT")"

if [ "$CHECK" == "$IFEXT" ]; then
    log "Deactivating network interface $IFIN"
    systemctl stop "netctl-auto@$IFIN.service"
    log "Activating network interface $IFEXT"
    systemctl start "netctl-auto@$IFEXT.service" &
fi
