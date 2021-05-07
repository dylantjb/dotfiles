# Defined in /tmp/fish.oPfoxP/upgrade-npm.fish @ line 1
function upgrade-npm
  sudo pacman -S npm --overwrite '/usr/lib/node_modules/npm/*'
end
