#!/usr/bin/env sh
set -eu

sudo rm -rf /etc/profile.d/custom.sh
rm -rf ~/.bashrc.d/
rm -rf ~/.gitconfig
sed -i '/[[ -f \/etc\/profile.d\/custom.sh ]] && . \/etc\/profile.d\/custom.sh/d' ~/.bashrc
