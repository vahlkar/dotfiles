#!/bin/bash

curl -s -X $'POST' \
    -H $'Host: 192.168.0.254' -H $'Content-Type: application/x-sah-ws-4-call+json' -H $'Content-Length: 63' \
    --data-binary $'{\"service\":\"Devices.Device.HGW\",\"method\":\"get\",\"parameters\":{}}' \
    $'http://192.168.0.254/ws' | jq -r '.status.ConnectionIPv4Address'
