#!/usr/bin/env bash
# set -eu

main() {
    devops
    electronics
}

devops() {
    echo "--> Install packages for devops."
    sudo pacman -S --noconfirm --needed \
        helm \
        jq \
        kubectl \
        minikube \
        percona-server-clients \
        percona-toolkit \
        virtualbox \
    &> /dev/null

    yay -Sy --noconfirm --needed \
        aws-cli-v2                 `#AWS CLI`                   \
        aws-session-manager-plugin `#AWS CLI SSM Plugin`        \
        slack-desktop              `#Slack`                     \
        sql-workbench              `#SQL Client`                \
        vscodium-bin               `#VS Code`                   \
        virtualbox-ext-oracle      `#VirtualBox Extension Pack` \
        zoom                       `#Zoom meeting client`       \
    &> /dev/null
}

electronics() {
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
