function ovpn
  if [ "$argv" ]
    set TARGET $argv
  else
    set TARGET ch
  end
  set SERVER (ls -alh "$VPN" | awk '{ print $9 }' | grep ovpn | grep "$TARGET" | sort -R | head -1)
  if [ "$SERVER" ]
    sudo openvpn "$VPN/$SERVER"
  else
    echo "No server found for filter $TARGET"
  end
end
