# Host-specific profile configuration (gallifrey)

# GPG agent
command -v gpg-connect-agent > /dev/null && gpg-connect-agent /bye
export SSH_AUTH_SOCK="/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
