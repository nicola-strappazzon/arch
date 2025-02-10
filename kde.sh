#!/usr/bin/env bash
# set -eu

main() {
    update
    ntp
    desktop
}

update() {
    sudo pacman -Sy &> /dev/null
}

ntp() {
    echo "--> Configure time zone and NTP."
    sudo timedatectl set-timezone Europe/Madrid
    sudo timedatectl set-ntp true
    sudo hwclock --systohc
}

desktop() {
    echo "--> Install desktop."
    sudo pacman -S --noconfirm --needed \
        plasma-meta \
        sddm \
    &> /dev/null

    sudo systemctl enable sddm.service &> /dev/null
}
