# Host-specific fish configuration (gallifrey)

set -x BORG_REPO "/run/media/volodia/61bf0c76-0358-4114-aa8f-3af3f4c419d2/home/volodia/backup"
set -x VPN $HOME/work/tools/nordvpn/ovpn_udp
fish_add_path "$HOME/Android/Sdk/emulator"

# GPG alternate keyring
set GNUPG_ALT_KEYRING "~/.gnupg-alt-keyring"
function altkeyring
  /usr/bin/gpg2 --homedir "$GNUPG_ALT_KEYRING" $argv
end
