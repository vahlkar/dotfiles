set -x GPG_TTY (tty)
set -x EDITOR vim
set -x VISUAL vim
set -x BORG_REPO "/run/media/volodia/61bf0c76-0358-4114-aa8f-3af3f4c419d2/home/volodia/backup"
set -x VPN $HOME/work/tools/nordvpn/ovpn_udp
set -x GEM_HOME "$HOME/.gems"
set -x GRIM_DEFAULT_DIR "$HOME/Pictures/Autres/Screenshots/"

fish_add_path "$HOME/bin"
fish_add_path "$GEM_HOME/bin"
fish_add_path "$HOME/.gem/ruby/3.0.0/bin"
fish_add_path "$HOME/Android/Sdk/emulator"

if status --is-login
    # GPG Agent
    gpg-connect-agent /bye
    #export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
    set -x SSH_AUTH_SOCK "/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
end
