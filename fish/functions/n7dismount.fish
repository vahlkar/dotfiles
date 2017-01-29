set N7REMOTE $HOME/.n7home
function n7dismount
  fusermount -u $N7REMOTE
end
