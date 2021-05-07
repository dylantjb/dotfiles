# Defined in /tmp/fish.RZj3rT/ranger-cd.fish @ line 1
function ranger-cd
    set dir (mktemp -t ranger_cd.XXX)
    ranger --choosedir=$dir
    cd (cat $dir) $argv
    rm $dir
    commandline -f repaint
end
