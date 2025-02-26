#!/usr/bin/env bash
# set -eu

declare VOLUMEN;

function main() {
    partitioning
}

function partitioning() {
    readarray -t VOLUMES < <(lsblk --list --nvme --nodeps --ascii --noheadings --output=NAME | sort)

    echo "--> Available volumes:"
    echo "  > Choice volume to install: "
    IFS="" read -r -s -p "    Enter your password: " VOLUMEN </dev/tty

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
