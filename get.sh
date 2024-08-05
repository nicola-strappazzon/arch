#!/usr/bin/env sh
set -eu

declare -A osInfo;
declare platform;
declare arch;

main() {
    check_is_not_root
    platform="$(uname -s)"
    arch="$(uname -m)"
    check_valid_platform
    check_valid_platform_architecture
    check_exist_curl_or_wget
    tmp="$(mktemp -d "/tmp/strappazzon-XXXXXX")"
    pms=($(package_manager_system))

    echo "OS: ${platform}-${arch}"
    echo "Package manager: ${pms}"
}

check_is_not_root() {
    if [[ $EUID -eq 0 ]]; then
        echo "This script must be run as not root"
        exit 1
    fi
}

check_valid_platform() {
    if [ "$platform" = "Darwin" ]; then
        platform="macos"
    elif [ "$platform" = "Linux" ]; then
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
        echo "Could not find 'curl' or 'wget' in your path"
        exit 1
    fi
}

package_manager_system() {
    osInfo[/etc/redhat-release]=yum
    osInfo[/etc/arch-release]=pacman
    osInfo[/etc/gentoo-release]=emerge
    osInfo[/etc/SuSE-release]=zypp
    osInfo[/etc/debian_version]=apt-get
    osInfo[/etc/alpine-release]=apk

    for f in ${!osInfo[@]}
    do
        if [[ -f $f ]];then
            echo "${osInfo[$f]}"
        fi
    done
}

main "$@"
