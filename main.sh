#!/usr/bin/env bash
# set -eu

declare PLATFORM
declare ARCH

function main() {
    PLATFORM="$(uname -s)"
    ARCH="$(uname -m)"

    check_valid_platform
    check_valid_platform_architecture
    check_valid_distribution
    check_exist_curl
    banner

    if [ "$#" -eq 1 ]; then
        run_remote_script "$1"
        exit 0
    else
        show_help
    fi
}

function banner() {
    reset
    clear

    echo "                                                                                                                                                          "
    echo "                                                                                                                                       ##                 "
    echo "                                                                                                                                      ####                "
    echo "                                                                                                                                     ######               "
    echo " ███╗   ██╗██╗ ██████╗ ██████╗ ██╗      █████╗  ██████╗                                                                             ########              "
    echo " ████╗  ██║██║██╔════╝██╔═══██╗██║     ██╔══██╗██╔═══██╗                                                                           ##########             "
    echo " ██╔██╗ ██║██║██║     ██║   ██║██║     ███████║██║██╗██║                                                                          ############            "
    echo " ██║╚██╗██║██║██║     ██║   ██║██║     ██╔══██║██║██║██║                                                                         ##############           "
    echo " ██║ ╚████║██║╚██████╗╚██████╔╝███████╗██║  ██║╚█║████╔╝                                                                        ################          "
    echo " ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚╝╚═══╝                                                                        ##################         "
    echo " ███████╗████████╗██████╗  █████╗ ██████╗ ██████╗  █████╗ ███████╗███████╗ ██████╗ ███╗   ██╗   ███╗   ███╗███████╗           ####################        "
    echo " ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚══███╔╝╚══███╔╝██╔═══██╗████╗  ██║   ████╗ ████║██╔════╝          ######################       "
    echo " ███████╗   ██║   ██████╔╝███████║██████╔╝██████╔╝███████║  ███╔╝   ███╔╝ ██║   ██║██╔██╗ ██║   ██╔████╔██║█████╗           #########      #########      "
    echo " ╚════██║   ██║   ██╔══██╗██╔══██║██╔═══╝ ██╔═══╝ ██╔══██║ ███╔╝   ███╔╝  ██║   ██║██║╚██╗██║   ██║╚██╔╝██║██╔══╝          ##########      ##########     "
    echo " ███████║   ██║   ██║  ██║██║  ██║██║     ██║     ██║  ██║███████╗███████╗╚██████╔╝██║ ╚████║██╗██║ ╚═╝ ██║███████╗       ###########      ###########    "
    echo " ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚══════╝      ##########          ##########   "
    echo "                                                                                                                        #######                  #######  "
    echo "                                                                                                                       ####                          #### "
    echo "                                                                                                                      ###                              ###"
    echo ""
}

function check_valid_distribution() {
    if [ ! -f /etc/arch-release ]; then
        echo "Unsupported linux distribution."
        exit 1
    fi
}

function check_valid_platform() {
    if [ "$PLATFORM" = "Linux" ]; then
        PLATFORM="linux"
    else
        echo "Unsupported platform $PLATFORM"
        exit 1
    fi
}

function check_valid_platform_architecture() {
    case "$PLATFORM-$ARCH" in
        linux-x86* | linux-i686*)
            ARCH="x86_64"
            ;;
        *)
            echo "Unsupported platform or architecture"
            exit 1
            ;;
    esac
}

function check_exist_curl() {
    if { ! command -v curl; }  2>&1; then
        echo "Could not find 'curl', please install: pacman -Sy curl"
        exit 1
    fi
}

function run_remote_script() {
    URI="https://raw.githubusercontent.com/nicola-strappazzon/arch/main/$1.sh?t=$(date +%s)"
    if curl --output /dev/null --silent --head --fail "${URI}"; then
        echo "Run script: ${URI}"
        echo ""
        curl -s -f -L "${URI}" | sh
    else
        show_help
    fi
}

function show_help() {
    echo " Usage:"
    echo ""
    echo "  curl -s strappazzon.me | sh -s -- base"
    echo "  curl -s strappazzon.me | sh -s -- kde"
    echo "  curl -s strappazzon.me | sh -s -- packages"
    echo "  curl -s strappazzon.me | sh -s -- profile"
    echo ""
}

main "$@"
