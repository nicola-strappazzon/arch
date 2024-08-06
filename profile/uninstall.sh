#!/usr/bin/env sh
set -eu

sudo rm -rf /etc/profile.d/bashrc.sh
rm -rf ~/.bashrc.d/
rm -rf ~/.gitconfig
sed -i '/[[ -f \/etc\/profile.d\/bashrc.sh ]] && . \/etc\/profile.d\/bashrc.sh/d' ~/.bashrc
