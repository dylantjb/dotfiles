printotp() {
  otp=$(mktemp) && xclip -selection clipboard -t image/png -o > "$otp"
  zbarimg -q --raw "$otp"
}
