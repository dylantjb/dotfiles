metadata-yt() {
  for i in *.mp3; do 
    mid3v2 -T "$(echo "$i" | head -c2)" -a "$(basename "$(dirname $PWD)")" \
      -A "$(basename $PWD)" -t "$(basename -s ".mp3" "$i" | cut -c 6-)" "$i"
  done
}
