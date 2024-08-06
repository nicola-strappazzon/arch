#!/usr/bin/env sh
set -eu

git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global user.email nicola@strappazzon.me
git config --global user.name "Nicola Strappazzon."
