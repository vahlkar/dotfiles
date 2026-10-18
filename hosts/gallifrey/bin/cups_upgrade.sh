#!/bin/bash

# See https://www.reddit.com/r/archlinux/comments/5rdgfo/manually_updating_printer_ppd_using_cups_and/

cupsreject Canon_MP190_series
cupsdisable Canon_MP190_series
lpadmin -x Canon_MP190_series
cups-genppd.5.2 Canon_MP190_series
lpadmin -p Canon_MP190_series -E -v usb://Canon/MP190%20series?serial=53D962&interface=1 -m gutenprint.5.2://bjc-MP190-series/expert
lpoptions -d Canon_MP190_series
cupsenable Canon_MP190_series
cupsaccept Canon_MP190_series
lpstat -s
lpstat -p Canon_MP190_series
