#!/usr/bin/env sh
set -eu

sudo sed -i 's/#set bell-style none/set bell-style none/g' /etc/inputrc
