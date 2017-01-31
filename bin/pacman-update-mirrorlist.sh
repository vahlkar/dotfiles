#!/bin/bash

inpt='Server = http://depots.inpt.fr/archlinux/$repo/os/$arch'

PACMAN_D=/etc/pacman.d
mirrorlist="$PACMAN_D/mirrorlist"
mirrorlist_new="$PACMAN_D/mirrorlist.pacnew"
mirrorlist_old="$PACMAN_D/mirrorlist.old"
mirrorlist_backup="$PACMAN_D/mirrorlist.backup"
mirrorlist_tmp="/tmp/mirrorlist"

if [ -e "$mirrorlist_new" ]; then
    mirrorlist_orig="$mirrorlist_new"
elif [ -e "$mirrorlist_backup" ]; then
    mirrorlist_orig="$mirrorlist_backup"
else
    mirrorlist_orig="$mirrorlist"
fi

rm -f "$mirrorlist_tmp"
touch "$mirrorlist_tmp"

echo "Using $mirrorlist_orig as source and $mirrorlist_tmp as temporary buffer."
lines="$(grep -n "##" $mirrorlist_orig | sed -e 's/## //')"
for country in "$@"
do
    name="$(echo "$lines" | grep -m 1 -i ":$country" | cut -d ":" -f 2)"
    selection="$(echo "$lines" | grep -m 1 -A1 -i ":$country" | cut -d ":" -f 1)"
    l_start="$(echo "$selection" | head -1)"
    l_end="$(echo "$selection" | tail -1)"
    l_num="$(($l_end-$l_start))"
    echo "Selecting country $name."
    cat "$mirrorlist_orig" | tail -n "+$l_start" | head -n "$l_num" | sed -e 's/^#Server/Server/' >> "$mirrorlist_tmp"
done

read -p "Would you like to add the inpt repository before ranking? [y/n]" ans
if [ -z "$ans" ] || [ "$ans" == "y" ] || [ "$ans" == "Y" ]; then
    echo "Add: $inpt"
    echo "$inpt" >> "$mirrorlist_tmp"
else
    echo "OK won't do."
fi

echo "Ranking mirrors..."
ranked="$(rankmirrors -n 10 $mirrorlist_tmp)"
cp "$mirrorlist_orig" "$mirrorlist_tmp"
echo "$ranked" | head -1 >> "$mirrorlist_tmp"
echo "$ranked" | tail -10 >> "$mirrorlist_tmp"
tail -11 "$mirrorlist_tmp"

read -p "Would you like to save the modifications to ${mirrorlist}? [y/n]" ans
if [ -z "$ans" ] || [ "$ans" == "y" ] || [ "$ans" == "Y" ]; then
    # Backup current mirrorlist.
    echo "Backup $mirrorlist to $mirrorlist_old"
    sudo cp "$mirrorlist" "$mirrorlist_old"
    # Update mirrorlist.
    echo "Save to $mirrorlist"
    sudo cp "$mirrorlist_tmp" "$mirrorlist"
else
    echo "OK won't do."
fi

if [ -e "$mirrorlist_new" ]; then
    read -p "Would you like to move $mirrorlist_new to ${mirrorlist_backup}? [y/n]" ans
    if [ -z "$ans" ] || [ "$ans" == "y" ] || [ "$ans" == "Y" ]; then
        echo "Move $mirrorlist_new to $mirrorlist_backup"
        sudo mv "$mirrorlist_new" "$mirrorlist_backup"
    else
        echo "Won't do."
    fi
fi
