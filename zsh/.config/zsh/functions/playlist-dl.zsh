download-yt() {
    youtube-dl --download-archive $HOME/.cache/youtube-dl/${PWD##*/}.archive --extract-audio \
        --audio-format mp3 -w4 -o "%(title)s.%(ext)s" "$1"
}
