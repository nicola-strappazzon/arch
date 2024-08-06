#!/usr/bin/env sh
set -eu

mkdir -p ~/.bashrc.d/
mkdir -p ~/.bashrc.d/alias/
mkdir -p ~/.bashrc.d/env/
mkdir -p ~/.bashrc.d/functions/
cp -R "$(pwd)/profile/bashrc/." ~/.bashrc.d/
chmod -R 0700 ~/.bashrc.d

if [ ! -f /etc/profile.d/custom.sh ]; then
    sudo cp $(pwd)/profile/profile.sh /etc/profile.d/custom.sh
fi

if [ -f ~/.bashrc ]; then
    grep -qxF '[[ -f /etc/profile.d/custom.sh ]] && . /etc/profile.d/custom.sh' ~/.bashrc || \
    echo '[[ -f /etc/profile.d/custom.sh ]] && . /etc/profile.d/custom.sh' >> ~/.bashrc
fi
