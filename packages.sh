#!/usr/bin/env bash
# set -eu

function main() {
    yay_install
    devops
    docker
    electronics
    latex
}

function yay_install() {
    echo "--> Install yay tool."
    if ! type "git" > /dev/null; then
        echo "Could not find: git"
        exit 1
    fi

    if ! type "makepkg" > /dev/null; then
        echo "Could not find: makepkg"
        exit 1
    fi

    if ! type "go" > /dev/null; then
        echo "Could not find: go"
        exit 1
    fi

    if ! type "yay" &> /dev/null; then
        tmp="$(mktemp -d)"

        mkdir -p "$tmp"

        if [[ ! "${tmp}" || ! -d "${tmp}" ]]; then
            echo "Could not find ${tmp} dir"
            exit 1
        fi

        cd "$tmp" || return
        git clone https://aur.archlinux.org/yay.git &> /dev/null
        cd yay || return
        makepkg -sif --noconfirm &> /dev/null
    fi
}

function devops() {
    echo "--> Install packages for devops."
    sudo pacman -S --noconfirm --needed \
        alacritty \
        bat \
        fd \
        ffmpeg \
        helix \
        helm \
        imagemagick \
        jq \
        kubectl \
        lsd \
        minikube \
        nicotine+ \
        p7zip \
        percona-server-clients \
        percona-toolkit \
        poppler \
        ripgrep \
        shellcheck \
        ttf-nerd-fonts-symbols \
        virtualbox \
        yazi \
        zellij \
        zoxide \
    &> /dev/null

function yay_packages() {
    echo "--> Install yay packages."
    yay -Sy --noconfirm --needed \
        freetube       `# YouTube player` \
        google-chrome  `# Google Chrome`  \
        ivpn-ui        `# VPN Client`     \
    &> /dev/null
}

    yay -Sy --noconfirm --needed \
        aws-cli-v2                 `# AWS CLI`                   \
        aws-session-manager-plugin `# AWS CLI SSM Plugin`        \
        mongosh-bin                `# MongoDB client`            \
        rpk-bin                    `# Redpanda CLI`              \
        slack-desktop              `# Slack`                     \
        sql-workbench              `# SQL Client`                \
        virtualbox-ext-oracle      `# VirtualBox Extension Pack` \
        vscodium-bin               `# VS Code`                   \
        zoom                       `# Zoom meeting client`       \
    &> /dev/null

    VBoxManage setextradata global GUI/SuppressMessages all &> /dev/null
}

function electronics() {
    echo "--> Install packages for electronics."
    sudo pacman -S --noconfirm --needed \
        arduino-cli \
        avr-binutils \
        avr-gcc \
        avr-gdb \
        avr-libc \
        avrdude \
        dfu-programmer \
        minicom \
        kicad \
    &> /dev/null

    yay -Sy --noconfirm --needed \
        tio \
    &> /dev/null
}

function docker() {
    echo "--> Install docker."
    if ! type "docker" > /dev/null; then
        sudo pacman -S docker docker-compose --noconfirm --needed &> /dev/null
        sudo systemctl start docker.service &> /dev/null
        sudo systemctl enable docker.service &> /dev/null
        sudo usermod -aG docker "$USER" &> /dev/null
    fi
}

function latex() {
    echo "--> Install packages for latex."
    sudo pacman -S --noconfirm --needed \
      texmaker \
      texlive-latexextra \
      texlive-fontsextra \
      texlive-bibtexextra \
      texlive-humanities \
      texlive-langspanish \
      texlive-latexextra \
      texlive-mathscience \
      texlive-pictures \
      texlive-publishers \
    &> /dev/null
}

main "$@"
