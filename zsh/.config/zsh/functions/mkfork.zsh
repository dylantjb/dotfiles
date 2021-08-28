mkfork() {
  echo "#\/bin\/sh\n $1 &" > temp; sh temp; rm temp
}
