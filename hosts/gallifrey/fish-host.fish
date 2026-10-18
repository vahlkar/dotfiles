# Host-specific fish configuration (gallifrey)

# GPG agent
if status --is-login
    if command -q gpg-connect-agent
        gpg-connect-agent /bye
    end
    set -x SSH_AUTH_SOCK "/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
end

set -x BORG_REPO "/run/media/volodia/61bf0c76-0358-4114-aa8f-3af3f4c419d2/home/volodia/backup"
set -x VPN $HOME/work/tools/nordvpn/ovpn_udp
fish_add_path "$HOME/Android/Sdk/emulator"
fish_add_path "$HOME/.gem/ruby/3.0.0/bin"

# Local-only scripts, intentionally not linked or tracked in this repo
fish_add_path "$HOME/bin-private"

# GPG alternate keyring
set GNUPG_ALT_KEYRING "~/.gnupg-alt-keyring"
function altkeyring
  /usr/bin/gpg2 --homedir "$GNUPG_ALT_KEYRING" $argv
end

# OpenVPN launcher for the servers in $VPN
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
