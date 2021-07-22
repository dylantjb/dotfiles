passgen() {
    tr -dc 'A-Za-z0-9$2' </dev/urandom | head -c $1 ; echo
}
