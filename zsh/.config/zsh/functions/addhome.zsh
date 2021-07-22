addhome() {
  cd $1
  git remote add home git@dylantjb.com:/srv/git/$1.git 
  git remote set-url --add --push origin git@dylantjb.com:/srv/git/$1.git 
  git remote set-url --add --push origin git@github.com:dylantjb/$1.git
  git push -u --all
  cd - > /dev/null
}
