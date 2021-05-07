# Defined in /tmp/fish.F7OiJP/syncbin.fish @ line 2
function syncbin
    rm ~/bin/*
    for i in (find /home/dylan/scripts -type f)
        echo $i
        chmod +x $i
        ln -sfn $i /home/dylan/bin
    end
end
