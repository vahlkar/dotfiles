set GNUPG_ALT_KEYRING "~/.gnupg-alt-keyring"
function altkeyring
  /usr/bin/gpg2 --homedir "$GNUPG_ALT_KEYRING" $argv
end
