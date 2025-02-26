#!/usr/bin/env bash
# set -eu

declare VOLUMEN;

main() {
    partitioning
}

partitioning() {
    echo "--> Available volumes:"
    readarray -t VOLUMES < <(lsblk --list --nodeps --ascii --noheadings --output=NAME | sort)

    PS3="  > Choice volume to install: "
    select VOLUMEN in "${VOLUMES[@]}"; do
        if [[ -z $VOLUMEN ]]; then
            echo "    Invalid choice, try again."
        else
            echo "  > Has chosen this volume: $VOLUMEN"
            VOLUMEN="/dev/${VOLUMEN}"
            break
        fi
    done

    echo "--> Umount partitions."
}

main "$@"
