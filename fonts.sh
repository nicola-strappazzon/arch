#!/usr/bin/env bash
# set -eu

function main() {
    echo "--> Install fonts."
    sudo pacman -S --noconfirm --needed \
      adobe-source-code-pro-fonts \
      noto-fonts \
      noto-fonts-cjk \
      noto-fonts-emoji \
      noto-fonts-extra \
      ttf-dejavu \
      ttf-fira-code \
      ttf-hack \
      ttf-jetbrains-mono \
      ttf-jetbrains-mono-nerd \
      ttf-liberation \
      ttf-roboto \
    &> /dev/null

    sudo fc-cache -fv
}

main "$@"
