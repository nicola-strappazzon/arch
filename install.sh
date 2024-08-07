#!/usr/bin/env sh
set -eu

declare ISO

main() {
    iso
    ntp
    mirror
    keyboard
}

iso() {
    ISO=$(curl -s -4 ifconfig.co/country-iso)
}

ntp() {
    timedatectl set-timezone Europe/Madrid
    timedatectl set-ntp true
    hwclock --systohc
}

mirror() {
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    reflector -a 48 -c $ISO -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
    pacman -Sy
}

keyboard() {
    loadkeys us
}

main "$@"
