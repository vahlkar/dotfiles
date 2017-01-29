#!/bin/bash
find . -name "*.jpeg" -exec fish -c "convert {} -resize 1366x768^ -gravity Center -crop 1366x768+0+0 +repage ~/.config/i3/lock-screen/(basename {} .jpeg).png" \;
