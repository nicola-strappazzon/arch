#!/usr/bin/env bash
# set -eu

main() {
    packages
}

packages() {
    echo "--> Install packages for devops."
    sudo pacman -S --noconfirm --needed \
        helm \
        jq \
        kubectl \
        minikube \
        percona-server-clients \
        percona-toolkit \
        virtualbox \
    &> /dev/null

    yay -Sy --noconfirm --needed \
        aws-cli-v2                 `#AWS CLI`                   \
        aws-session-manager-plugin `#AWS CLI SSM Plugin`        \
        slack-desktop              `#Slack`                     \
        sql-workbench              `#SQL Client`                \
        vscodium-bin               `#VS Code`                   \
        virtualbox-ext-oracle      `#VirtualBox Extension Pack` \
        zoom                       `#Zoom meeting client`       \
    &> /dev/null
}

main "$@"
