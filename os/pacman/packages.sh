#!/usr/bin/env sh
set -eu

declare -I EXITCODE=0
declare -A PACKAGES=(
    base
    base-devel
    bash-completion
    bind-tools
    btop
    curl
    git
    htop
    jq
    minicom
    neofetch
    net-tools
    nmap
    pass
    pass-otp
    rsync
    tmux
    usbutils
    wget
    fzf
)

sudo pacman -Syu --noconfirm

for PACKAGE in "${PACKAGES[@]}"; do
    EXITCODE=0
    pacman -Q "${PACKAGE}" &> /dev/null || EXITCODE=$?

    if [ "${EXITCODE}" -ne 0 ]; then
        sudo pacman -S "$PACKAGE" --noconfirm --needed
    fi
done
