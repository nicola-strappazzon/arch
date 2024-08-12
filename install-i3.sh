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
        noto-fonts-cjk \
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
        # ttf-nerd-fonts-symbols

     pacman -S --noconfirm --needed \
        i3-wm \
        polybar \
        feh \
        lxappearance

     pacman -S --noconfirm --needed sddm
     systemctl enable sddm.service

     pacman -S --noconfirm --needed \
        rofi \
        rofi-calc \
        rofi-emoji \
        rofi-pass

     pacman -S --noconfirm --needed \
        firefox


}

yay() {
    echo "--> Install yay."

    arch-chroot /mnt /bin/bash -- << EOCHROOT
mkdir -p /root/yay/
git clone https://aur.archlinux.org/yay.git /root/yay/ #&> /dev/null
#cd /root/yay
#makepkg -rsi
#cd ..
#rm -rf /root/yay
EOCHROOT

#&> /dev/null

    PACKAGES=(
        moc-pulse
    )

#     for PACKAGE in "${PACKAGES[@]}"; do
#         arch-chroot /mnt yay -S "${PACKAGE}" --noconfirm --needed # &> /dev/null
#     done
}

main "$@"
