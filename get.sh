#!/usr/bin/env sh
set -eu

main() {
    platform="$(uname -s)"
    arch="$(uname -m)"
}

main "$@"
