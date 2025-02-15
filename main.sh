#!/usr/bin/env sh
set -eu

platform=""
arch=""

main() {
    platform="$(uname -s)"
    arch="$(uname -m)"

    check_valid_platform
    check_valid_platform_architecture
    check_valid_distribution
    check_exist_curl
    banner

    if [ "$#" -eq 1 ]; then
        run_remote_script "$1"
        exit 0
    fi
}

banner() {
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

check_valid_distribution() {
    if [ ! -f /etc/arch-release ]; then
        echo "Unsupported linux distribution."
        exit 1
    fi
}

check_valid_platform() {
    if [ "$platform" = "Linux" ]; then
        platform="linux"
    else
        echo "Unsupported platform $platform"
        exit 1
    fi
}

check_valid_platform_architecture() {
    case "$platform-$arch" in
        linux-x86* | linux-i686*)
            arch="x86_64"
            ;;
        *)
            echo "Unsupported platform or architecture"
            exit 1
            ;;
    esac
}

check_exist_curl() {
    if { ! command -v curl; }  2>&1; then
        echo "Could not find 'curl', please install: pacman -Sy curl"
        exit 1
    fi
}

run_remote_script() {
    URI="https://raw.githubusercontent.com/nstrappazzonc/get/main/$1.sh"
    if curl --output /dev/null --silent --head --fail "${URI}"; then
        echo "Run script: ${URI}"
        echo ""
        curl -s -f -L "${URI}" | sh
    else
        echo " Usage:"
        echo ""
        echo "  curl -sfL strappazzon.me/arch | sh -s -- base"
        echo "  curl -sfL strappazzon.me/arch | sh -s -- desktop"
        echo "  curl -sfL strappazzon.me/arch | sh -s -- profile"
        echo ""
    fi
}

main "$@"
