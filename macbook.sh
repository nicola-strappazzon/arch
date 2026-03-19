#!/usr/bin/env bash
# set -eu

function main() {
  echo "==> Install drivers."
  sudo pacman --sync --noconfirm broadcom-wl-dkms
  sudo modprobe wl

  # Connect to wifi:
  # ================
  # nmcli device wifi list
  # sudo nmcli device wifi connect YourSSID password YourPassword

  sudo pacman --sync --noconfirm --needed \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    wireplumber \
    alsa-utils \
    pamixer \
    playerctl \
    pavucontrol \
    &> /dev/null

  echo "==> Enable services."

  systemctl --user enable --now pipewire pipewire-pulse wireplumber

  # Test sound:
  # ===========
  # pactl info
  # pactl list short sinks
  # speaker-test -c 2
}

main "$@"
