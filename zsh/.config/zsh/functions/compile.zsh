compile() {
  g++ --std=c++11 -g -o "${1%.*}" "$1"
}
