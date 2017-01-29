function tmux
  /usr/bin/systemd-run --scope --user /usr/bin/tmux $argv
end
