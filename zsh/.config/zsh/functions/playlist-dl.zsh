download-yt() {
    youtube-dl --extract-audio --audio-format mp3 -w4 -o "%(title)s.%(ext)s" "$1"
}
