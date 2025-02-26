#!/usr/bin/env bash
# set -eu

declare VOLUMEN;

function main() {
    partitioning
}

function partitioning() {
# Scriptname: runit
    PS3="Select a program to execute: "
    select program in 'ls -F' pwd date cal exit
    do
    $program
    done

    readarray -t VOLUMES < <(lsblk --list --nvme --nodeps --ascii --noheadings --output=NAME | sort)

    echo "--> Available volumes:"
    for VOLUMEN in "${VOLUMES[@]}"; do
        echo "    - ${VOLUMEN}"
    done
    IFS="" read -r -p "  > Choice volume to install: " VOLUMEN </dev/tty
    if [[ -z $VOLUMEN ]]; then
        echo "    Invalid choice, try again."
    fi


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
