set N7REMOTE $HOME/.n7home
function n7mount
  if [ "$argv" ]
    set N7MACHINE $argv
  else
    set N7MACHINE pikachu
  end
  sshfs vlaniel@$N7MACHINE.enseeiht.fr:/home/vlaniel/Documents $N7REMOTE/
end
