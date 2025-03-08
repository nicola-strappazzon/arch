#!/usr/bin/env bash
# set -eu

function main() {
    update
    desktop
    packages
    printing
    finish
}

function update() {
    sudo pacman -Sy &> /dev/null
}

function desktop() {
    echo "--> Install desktop."
    sudo pacman -S --noconfirm --needed \
        plasma-meta \
        sddm \
    &> /dev/null

    sudo systemctl enable sddm.service &> /dev/null
}

function packages() {
    echo "--> Install packages."
    sudo pacman -S --noconfirm --needed \
        ark              `#Archiving Tool`             \
        dolphin          `#File manager`               \
        elisa            `#Music player`               \
        firefox          `#Web browser`                \
        gwenview         `#Image viewer`               \
        hunspell-en_us   `#Spell dictionary EN`        \
        hunspell-es_es   `#Spell dictionary ES`        \
        kamoso           `#Camera tool`                \
        kate             `#Code editor`                \
        kbackup          `#Backup tool`                \
        kcalc            `#Calculator`                 \
        kcharselect      `#select special characters`  \
        kcolorchooser    `#color palette tool`         \
        kfind            `#Find files`                 \
        kid3             `#Audio tag editor`           \
        kmix             `#Sound channel mixer`        \
        konsole          `#Terminal client`            \
        ksystemlog       `#Show all logs`              \
        ktorrent         `#Torrent client`             \
        okteta           `#Hex editor`                 \
        okular           `#Document viewer`            \
        partitionmanager `#Partition Manager`          \
        powerdevil       `#Power consumption settings` \
        rssguard         `#RSS Client`                 \
        spectacle        `#Screenshots`                \
        thunderbird      `#Email client`               \
    &> /dev/null
}

function printing() {
    echo "--> Install printing system."
    sudo pacman -S --noconfirm --needed \
        cups                  `#Printing system`               \
        system-config-printer `#Print settings`                \
        hplip                 `#hp linux imaging and printing` \
    &> /dev/null

    sudo systemctl start cups.service &> /dev/null
    sudo systemctl enable cups.service &> /dev/null
}

function finish() {
    echo "--> Optional, please type: reboot"
    echo "    To use KDE only if out of desktop environment."
}

main "$@"
