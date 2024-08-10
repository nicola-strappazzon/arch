#!/usr/bin/env bash
# set -eu

main() {
    pacman -S --noconfirm --needed xf86-video-amdgpu

#    pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
#    sudo systemctl enable lightdm.service

#     pacman -S --noconfirm --needed xorg plasma plasma-wayland-session kde-applications

    pacman -S --noconfirm --needed \
        xorg \
        xorg-server \
        xorg-xinit \
        xorg-fonts-misc \
        xterm

#     sudo pacman -S i3-gaps i3status ttf-dejavu


#     pacman -S --noconfirm --needed sddm
#     systemctl enable sddm.service
}

main "$@"
