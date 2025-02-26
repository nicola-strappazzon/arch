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
}

main "$@"
