#!/usr/bin/env sh
set -eu

declare -I EXITCODE=0
declare -A PACKAGES=(
    aws-cli
    base
    base-devel
    bash-completion
    bind-tools
    btop
    ca-certificates
    curl
    docker
    fzf
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
    traceroute
    unrar
    unzip
    usbutils
    vim
    wget
)

sudo pacman -Syu --noconfirm

for PACKAGE in "${PACKAGES[@]}"; do
    EXITCODE=0
    pacman -Q "${PACKAGE}" &> /dev/null || EXITCODE=$?

    if [ "${EXITCODE}" -ne 0 ]; then
        echo "Install package: ${PACKAGE}"
        sudo pacman -S "${PACKAGE}" --noconfirm --needed
    fi
done
