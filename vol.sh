#!/usr/bin/env bash
# set -eu

declare VOLUMEN;

function main() {
    partitioning
}

function partitioning() {
    readarray -t VOLUMES < <(lsblk --list --nvme --nodeps --ascii --noheadings --output=NAME | sort)

    echo "--> Available volumes:"
    for VOLUMEN in "${VOLUMES[@]}"; do
        echo "  - ${VOLUMEN}"
    done
    IFS="" read -r -s -p "  > Choice volume to install: " VOLUMEN </dev/tty

#     select VOLUMEN in "${VOLUMES[@]}"; do
#         if [[ -z $VOLUMEN ]]; then
#             echo "    Invalid choice, try again."
#         else
#             echo "  > Has chosen this volume: $VOLUMEN"
#             VOLUMEN="/dev/${VOLUMEN}"
#             break
#         fi
#     done

    echo "--> Umount partitions."
}

main "$@"
