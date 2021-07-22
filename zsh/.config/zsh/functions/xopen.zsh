xopen() {
    autosave=".${1%.*}.autosave.${1##*.}"
    [ -f "$autosave" ] && mv "$autosave" "$1"
    xournalpp "$1"
}
