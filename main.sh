#!/usr/bin/env sh
set -eu

declare -G TMP;
declare -A osPMS;
declare platform;
declare arch;
declare pms;

main() {
    platform="$(uname -s)"
    arch="$(uname -m)"

    check_valid_platform
    check_valid_platform_architecture
    check_valid_distribution
    check_exist_curl_or_wget
    banner

    if [ "$#" -eq 1 ]; then
        run_remote_script $1
        exit 0
    fi
}

banner() {
    reset
    clear
    echo ""
    echo " ███╗   ██╗██╗ ██████╗ ██████╗ ██╗      █████╗  ██████╗                                                            "
    echo " ████╗  ██║██║██╔════╝██╔═══██╗██║     ██╔══██╗██╔═══██╗                                                           "
    echo " ██╔██╗ ██║██║██║     ██║   ██║██║     ███████║██║██╗██║                                                           "
    echo " ██║╚██╗██║██║██║     ██║   ██║██║     ██╔══██║██║██║██║                                                           "
    echo " ██║ ╚████║██║╚██████╗╚██████╔╝███████╗██║  ██║╚█║████╔╝                                                           "
    echo " ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚╝╚═══╝                                                            "
    echo " ███████╗████████╗██████╗  █████╗ ██████╗ ██████╗  █████╗ ███████╗███████╗ ██████╗ ███╗   ██╗   ███╗   ███╗███████╗"
    echo " ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗╚══███╔╝╚══███╔╝██╔═══██╗████╗  ██║   ████╗ ████║██╔════╝"
    echo " ███████╗   ██║   ██████╔╝███████║██████╔╝██████╔╝███████║  ███╔╝   ███╔╝ ██║   ██║██╔██╗ ██║   ██╔████╔██║█████╗  "
    echo " ╚════██║   ██║   ██╔══██╗██╔══██║██╔═══╝ ██╔═══╝ ██╔══██║ ███╔╝   ███╔╝  ██║   ██║██║╚██╗██║   ██║╚██╔╝██║██╔══╝  "
    echo " ███████║   ██║   ██║  ██║██║  ██║██║     ██║     ██║  ██║███████╗███████╗╚██████╔╝██║ ╚████║██╗██║ ╚═╝ ██║███████╗"
    echo " ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚══════╝"
    echo ""
}

check_valid_distribution() {
    if [[ ! -f /etc/arch-release ]]; then
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
        macos-arm64* | linux-arm64* | linux-armhf | linux-aarch64)
            arch="aarch64"
            ;;
        macos-x86* | linux-x86* | linux-i686*)
            arch="x86_64"
            ;;
        *)
            echo "Unsupported platform or architecture"
            exit 1
            ;;
    esac
}

check_exist_curl_or_wget(){
    if which curl >/dev/null 2>&1; then
        curl () {
            command curl -sfL "$@"
        }
    elif which wget >/dev/null 2>&1; then
        curl () {
        wget -O- "$@"
        }
    else
        echo "Could not find; 'curl' or 'wget'"
        exit 1
    fi
}

run_remote_script() {
    URI="https://raw.githubusercontent.com/nstrappazzonc/get/main/$1.sh"
    if curl --output /dev/null --silent --head --fail "${URI}"; then
        echo "Run script: ${URI}"
        echo ""
        curl -s -f -L "${URI}" | sh
    fi
}

main "$@"
