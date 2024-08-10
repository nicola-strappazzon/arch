#!/usr/bin/env bash
# set -eu

main() {
    pacman -S --noconfirm --needed xf86-video-amdgpu

    pacman -S --noconfirm --needed \
        xorg \
        xorg-server \
        xorg-xinit \
        xorg-fonts-misc \
        xorg-mkfontscale \
        xterm

    pacman -S --noconfirm --needed \
        adobe-source-sans-fonts \
        noto-fonts \
        noto-fonts-emoji \
        terminus-font \
        ttf-dejavu \
        ttf-droid \
        ttf-font-awesome \
        ttf-font-icons \
        ttf-inconsolata \
        ttf-indic-otf \
        ttf-ionicons \
        ttf-liberation

     pacman -S --noconfirm --needed \
        i3-wm \
        i3status

     pacman -S --noconfirm --needed sddm
     systemctl enable sddm.service
}

main "$@"
