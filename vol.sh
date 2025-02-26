#!/usr/bin/env bash
# set -eu

declare VOLUMEN;
declare VOLUMEN_ID;

function main() {
    partitioning
}

function partitioning() {
    readarray -t VOLUMES_LIST < <(lsblk --list --nvme --nodeps --ascii --noheadings --output=NAME | sort)
    VOLUMENS_COUNT=$(( ${#VOLUMES_LIST[@]} - 1 ))

    echo "--> Available volumes:"
    for VOLUMEN_INDEX in "${!VOLUMES_LIST[@]}"; do
        echo "    ${VOLUMEN_INDEX}. ${VOLUMES_LIST[$VOLUMEN_INDEX]}"
    done

    until [[ $VOLUMEN_ID =~ ^[0-${VOLUMENS_COUNT}]$ ]]; do
        IFS="" read -r -p "  > Choice volume number: " VOLUMEN_ID </dev/tty
    done

    VOLUMEN="/dev/${VOLUMES_LIST[$VOLUMEN_ID]}"
    echo "  > Has chosen this volume: $VOLUMEN"

    echo "--> Umount partitions."
    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true

    echo "--> Delete old partitions."
    (parted --script $VOLUMEN rm 1 &> /dev/null) || true
    (parted --script $VOLUMEN rm 2 &> /dev/null) || true
    (parted --script $VOLUMEN rm 3 &> /dev/null) || true

    echo "--> Create new partitions."
    parted --script $VOLUMEN mklabel gpt
    parted --script $VOLUMEN mkpart efi fat32 1MiB 1024MiB
    parted --script $VOLUMEN set 1 esp on
    parted --script $VOLUMEN mkpart swap linux-swap 1GiB 32GiB
    parted --script $VOLUMEN mkpart root ext4 32GiB 100%

    echo "--> Format partitions."
    mkfs.fat -F32 -n UEFI "${VOLUMEN}p1" &> /dev/null
    mkswap -L SWAP "${VOLUMEN}p2" &> /dev/null
    mkfs.ext4 -L ROOT "${VOLUMEN}p3" &> /dev/null

    echo "--> Verify partitions."
    partprobe $VOLUMEN

    echo "--> Mount: swap, root and boot"
    swapon "${VOLUMEN}p2"
    mount "${VOLUMEN}p3" /mnt
    mkdir -p /mnt/boot/efi/
    mount "${VOLUMEN}p1" /mnt/boot/efi/

    echo "--> Remove default directories lost+found."
    rm -rf /mnt/boot/efi/lost+found
    rm -rf /mnt/lost+found

    echo "--> Generate fstab."
    mkdir /mnt/etc/
    genfstab -pU /mnt >> /mnt/etc/fstab
}

main "$@"
