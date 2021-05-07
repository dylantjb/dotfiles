# Defined in /tmp/fish.w2E356/mkcd.fish @ line 2
function mkcd
  test -d $argv || mkdir $argv
  cd $argv
end
