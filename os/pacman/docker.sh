#!/usr/bin/env sh
set -eu

declare -I EXITCODE=0

pacman -Q "${PACKAGE}" &> /dev/null || EXITCODE=$?

if [ "${EXITCODE}" -ne 0 ]; then
    sudo pacman -S docker --noconfirm --needed
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    newgrp docker
    sudo usermod -aG docker $USER
fi
