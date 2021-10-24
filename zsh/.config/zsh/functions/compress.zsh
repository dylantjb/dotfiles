compress() {
  magick "$1" -strip -interlace Plane -gaussian-blur 0.05 -quality 85% "$2"
}
