#!/usr/bin/env bash
# set -eu

function main() {
    devops
    electronics
}

function devops() {
    echo "--> Install packages for devops."
    sudo pacman -S --noconfirm --needed \
        bat \
        helm \
        jq \
        kubectl \
        minikube \
        percona-server-clients \
        percona-toolkit \
        virtualbox \
        lsd \
        yazi \
        ffmpeg \
        p7zip \
        poppler \
        fd \
        ripgrep \
        zoxide \
        imagemagick \
        ttf-nerd-fonts-symbols \
    &> /dev/null

    yay -Sy --noconfirm --needed \
        aws-cli-v2                 `#AWS CLI`                   \
        aws-session-manager-plugin `#AWS CLI SSM Plugin`        \
        mongosh-bin                `#MongoDB client`            \
        slack-desktop              `#Slack`                     \
        sql-workbench              `#SQL Client`                \
        virtualbox-ext-oracle      `#VirtualBox Extension Pack` \
        vscodium-bin               `#VS Code`                   \
        zoom                       `#Zoom meeting client`       \
    &> /dev/null
}

function electronics() {
    echo "--> Install packages for electronics."
    sudo pacman -S --noconfirm --needed \
        arduino-cli \
        avr-binutils \
        avr-gcc \
        avr-gdb \
        avr-libc \
        avrdude \
        dfu-programmer \
        minicom \
        kicad \
    &> /dev/null

    yay -Sy --noconfirm --needed \
        tio \
    &> /dev/null
}

main "$@"
