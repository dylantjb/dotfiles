captureotp() {
    zbarcam -q --raw | pass otp append $1
} 
