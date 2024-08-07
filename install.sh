#!/usr/bin/env sh
set -eu

declare ISO;
declare -I EXITCODE=0;

main() {
    iso
    ntp
    mirror
    keyboard
    partitioning
}

iso() {
    ISO=$(curl -s -4 ifconfig.co/country-iso)
}

ntp() {
    timedatectl set-timezone Europe/Madrid
    timedatectl set-ntp true
    hwclock --systohc
}

mirror() {
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    reflector -a 48 -c $ISO -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
    pacman -Sy
}

keyboard() {
    loadkeys us
}

partitioning() {
    partition_delete 1
    partition_delete 2
    partition_delete 3

    parted -s /dev/sda mklabel gpt
    parted -s /dev/sda mkpart efi fat32 1MiB 1024MiB
    parted -s /dev/sda set 1 esp on
    parted -s /dev/sda mkpart swap linux-swap 1GiB 2GiB
    parted -s /dev/sda mkpart root ext4 2GiB 100%
    mkfs.fat -F32 -n UEFI /dev/sda1
    mkswap -L SWAP /dev/sda2
    mkfs.ext4 -L ROOT /dev/sda3
    parted -s /dev/sda print
    partprobe /dev/sda
}

partition_delete() {
    partprobe "/dev/sda{$1}" --summary --dry-run &> /dev/null || EXITCODE=$?
    if [ "${EXITCODE}" -ne 0 ]; then
        parted -s "/dev/sda{$1}" rm $1
    fi
    EXITCODE=0
}

main "$@"
