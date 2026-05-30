#!/usr/bin/env bash
# set -eu

function main() {
  echo "==> Install drivers."
  sudo pacman --sync --noconfirm broadcom-wl-dkms &> /dev/null
  sudo modprobe wl &> /dev/null

  # Connect to wifi:
  # ================
  # nmcli device wifi list
  # sudo nmcli device wifi connect YourSSID password YourPassword
  # ip a
  # curl ifconfig.co

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

  systemctl --user enable --now pipewire pipewire-pulse wireplumber &> /dev/null

  # Test sound:
  # ===========
  # pactl info
  # pactl list short sinks
  # speaker-test -c 2
}

main "$@"
