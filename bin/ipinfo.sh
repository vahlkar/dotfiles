#!/bin/bash

curl -s 'https://ipinfo.io/' | jq -r '.ip'
