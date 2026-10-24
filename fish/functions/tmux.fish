function tmux
  # Wrap tmux in a transient user scope, but only when a systemd user
  # manager is actually reachable (not the case in containers, where
  # systemd-run --user fails to connect to the user scope bus).
  if systemctl --user is-system-running >/dev/null 2>&1
    /usr/bin/systemd-run --scope --user /usr/bin/tmux $argv
  else
    /usr/bin/tmux $argv
  end
end
