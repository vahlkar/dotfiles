set -x GPG_TTY (tty)
set -x EDITOR vim
set -x VISUAL vim
set -x GEM_HOME "$HOME/.gems"
set -x GRIM_DEFAULT_DIR "$HOME/Screenshots/"

fish_add_path "$HOME/bin"
fish_add_path "$GEM_HOME/bin"
fish_add_path "$HOME/.gem/ruby/3.0.0/bin"

if status --is-login
    # GPG Agent
    gpg-connect-agent /bye
    #export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
    set -x SSH_AUTH_SOCK "/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
end
