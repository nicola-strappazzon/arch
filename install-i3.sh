#!/usr/bin/env bash
# set -eu

main() {
    pacman -S --noconfirm --needed xf86-video-amdgpu

    pacman -S --noconfirm --needed \
        xorg \
        xorg-server \
        xorg-xinit \
        xorg-fonts-misc \
        xterm

    pacman -S --noconfirm --needed \
        ttf-dejavu

     pacman -S --noconfirm --needed \
        i3-wm \
        i3status

     pacman -S --noconfirm --needed sddm
     systemctl enable sddm.service
}

main "$@"
