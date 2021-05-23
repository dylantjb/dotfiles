saveotp() {
    otp=$(mktemp) && xclip -selection clipboard -t image/png -o > "$otp"
    zbarimg -q --raw "$otp" | pass otp append $1
}
