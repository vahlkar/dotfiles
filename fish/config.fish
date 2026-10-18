set -x GPG_TTY (tty)
set -x EDITOR vim
set -x VISUAL vim
set -x GEM_HOME "$HOME/.gems"
set -x GRIM_DEFAULT_DIR "$HOME/Pictures/Screenshots/"
set -x PYENV_ROOT $HOME/.pyenv

fish_add_path "$HOME/bin"
fish_add_path "$PYENV_ROOT/bin"
fish_add_path "$GEM_HOME/bin"

if status --is-login
    set -x _JAVA_AWT_WM_NONREPARENTING 1
end

# Load pyenv
if command -q pyenv
    pyenv init - fish | source
end

# Host-specific configuration
if test -e ~/.config/fish/host.fish
    source ~/.config/fish/host.fish
end
