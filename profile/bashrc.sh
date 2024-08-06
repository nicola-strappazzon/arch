#!/usr/bin/env sh
set -eu

mkdir -p ~/.bashrc.d/
mkdir -p ~/.bashrc.d/alias/
mkdir -p ~/.bashrc.d/env/
mkdir -p ~/.bashrc.d/functions/
cp -R "$(pwd)/bashrc/." ~/.bashrc.d/
chmod -R 0700 ~/.bashrc.d

if [ -f ~/.bashrc ]; then
    grep -qxF '[[ -f /etc/profile.d/bashrc.sh ]] && . /etc/profile.d/bashrc.sh' ~/.bashrc || \
    echo '[[ -f /etc/profile.d/bashrc.sh ]] && . /etc/profile.d/bashrc.sh' >> ~/.bashrc
fi
