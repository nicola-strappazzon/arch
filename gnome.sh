#!/usr/bin/env bash
# set -eu

function main() {
    update
    desktop
    packages
    configure
    finish
}

function update() {
    sudo pacman -Sy &> /dev/null
}

function desktop() {
    echo "--> Install desktop."    
    sudo pacman -S --noconfirm --needed \
        xorg xorg-server \
        gnome \
        gdm \
    &> /dev/null

    sudo systemctl enable gdm.service &> /dev/null
}

function packages() {
    echo "--> Install packages."
    sudo pacman -S --noconfirm --needed \
        newsflash             `# RSS reader`                 \
        fragments             `# BitTorrent client`          \
        firefox               `# Web browser`                \
        hunspell-en_us        `# Spell dictionary EN`        \
        hunspell-es_es        `# Spell dictionary ES`        \
        kid3                  `# Audio tag editor`           \
        gedit                 `# Text editor`                \
        system-config-printer `# Print settings`             \
        geary                 `# Email client`               \
    &> /dev/null
}

function finish() {
    echo "--> Optional, please type: reboot"
    echo "    To use GNOME only if out of desktop environment."
}

main "$@"
