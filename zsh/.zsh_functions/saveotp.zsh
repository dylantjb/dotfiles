saveotp() {
     xclip -selection clipboard -t image/png -o > /tmp/qrcode.png && zbarimg -q --raw /tmp/qrcode.png | pass otp append $1
}
