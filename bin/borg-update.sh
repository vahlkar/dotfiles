#!/bin/bash
REPOSITORY="$BORG_REPO"

LOG_FILE=/var/log/borg.log

# set -e
# read -p "Enter passphrase: " -r -s -t 10 BORG_PASSPHRASE
# set +e
# echo ""
# export BORG_PASSPHRASE

# Backup all of /home except a few excluded directories
echo "## $(date "+%F %H:%M:%S"): Backup" | tee -a "$LOG_FILE"
borg create -v --stats --progress -C lz4 \
    "$REPOSITORY::{hostname}-{now:%Y-%m-%dT%H:%M:%S}" \
    "$HOME" \
    "$DATA" \
    --exclude "$DATA/.cache" \
    --exclude "$DATA/.local" \
    --exclude "$DATA/.PlayOnLinux" \
    --exclude "$DATA/tmp" \
    --exclude "$HOME/Dropbox" \
    --exclude '*.swp' 2>&1 | tee -a "$LOG_FILE"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machine's archives also.
echo "## $(date "+%F %H:%M:%S"): Clean" | tee -a "$LOG_FILE"
borg prune -v --list "$REPOSITORY" \
    --prefix '{hostname}-' \
    --keep-within 2d \
    --keep-daily=7 \
    --keep-weekly=4 \
    --keep-monthly=6 \
    2>&1 | tee -a "$LOG_FILE"
