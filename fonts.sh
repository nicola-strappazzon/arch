#!/usr/bin/env bash
# set -eu

function main() {
    echo "--> Install fonts."
    sudo pacman -S --noconfirm --needed \
      # nerd-fonts
      noto-fonts \
      noto-fonts-cjk \
      noto-fonts-emoji \
      noto-fonts-extra \
      ttf-liberation \
      ttf-dejavu \
      ttf-roboto \
      ttf-jetbrains-mono \
      ttf-fira-code \
      ttf-hack \
      adobe-source-code-pro-fonts \
    &> /dev/null

    sudo fc-cache -fv
}

main "$@"
