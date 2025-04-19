#!/usr/bin/env bash
# set -eu

function main() {
    yay_install
    install_packages
    install_docker
    install_virtualbox
    install_electronics
    install_latex
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

function install_packages() {
    echo "--> Install aditional packages."
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

    yay -Sy --noconfirm --needed \
        aws-cli-v2                 `# AWS CLI`                   \
        aws-session-manager-plugin `# AWS CLI SSM Plugin`        \
        freetube                   `# YouTube player`            \
        google-chrome              `# Google Chrome`             \
        ivpn-ui                    `# VPN Client`                \
        mongosh-bin                `# MongoDB client`            \
        rpk-bin                    `# Redpanda CLI`              \
        slack-desktop              `# Slack`                     \
        sql-workbench              `# SQL Client`                \
        virtualbox-ext-oracle      `# VirtualBox Extension Pack` \
        vscodium-bin               `# VS Code`                   \
        zoom                       `# Zoom meeting client`       \
    &> /dev/null
}

function install_docker() {
    echo "--> Install docker."
    if ! command -v "docker" >/dev/null; then
        sudo pacman -S docker docker-compose --noconfirm --needed &> /dev/null
        sudo systemctl start docker.service &> /dev/null
        sudo systemctl enable docker.service &> /dev/null
        sudo usermod -aG docker "$USER" &> /dev/null
    fi
}

function install_virtualbox() {
    echo "--> Install VirtualBox."
    sudo pacman -S --noconfirm --needed \
        virtualbox \
    &> /dev/null

    yay -Sy --noconfirm --needed \
        virtualbox-ext-oracle \
    &> /dev/null

    VBoxManage setextradata global GUI/SuppressMessages all &> /dev/null
}

function install_electronics() {
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

    # Install Arduino IDE 1.x:
    tmp="$(mktemp -d)"

    mkdir -p "$tmp"

    if [[ ! "${tmp}" || ! -d "${tmp}" ]]; then
        echo "Could not find ${tmp} dir"
        exit 1
    fi

    cd "$tmp" || return

    wget --quiet https://downloads.arduino.cc/arduino-1.8.19-linux64.tar.xz
    tar -xf arduino-1.8.19-linux64.tar.xz > /dev/null 2>&1
    cd arduino-1.8.19/ || return
    sudo ./install.sh > /dev/null 2>&1

    rm "$HOME"/Desktop/arduino-arduinoide.desktop
}

function install_latex() {
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
