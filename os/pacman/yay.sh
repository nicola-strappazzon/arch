#!/usr/bin/env sh
set -eu

if ! type "git" > /dev/null; then
    echo "Could not find: git"
    exit 1
fi

if ! type "makepkg" > /dev/null; then
    echo "Could not find: makepkg"
    exit 1
fi

if ! type "yay" > /dev/null; then
    tmp="$(mktemp -d "/tmp/strappazzon-yay-XXXXXX")"

    if [[ ! "$tmp" || ! -d "$tmp" ]]; then
        echo "Could not create tmp dir"
        exit 1
    fi

    cd $tmp

    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    yay --version
fi
