function n7ssh
  if [ "$argv" ]
    set N7MACHINE $argv
  else
    set N7MACHINE pikachu
  end
  ssh -oConnectTimeout=2 vlaniel@$N7MACHINE.enseeiht.fr
end
