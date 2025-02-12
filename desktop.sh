#!/usr/bin/env bash
# set -eu

main() {
    update
    ntp
    desktop
    packages
    yay_install
    yay_packages
    printing
    docker
    finish
}

update() {
    sudo pacman -Sy &> /dev/null
}

ntp() {
    echo "--> Configure time zone and NTP."
    sudo timedatectl set-timezone Europe/Madrid
    sudo timedatectl set-ntp true
    sudo hwclock --systohc
}

desktop() {
    echo "--> Install desktop."
    sudo pacman -S --noconfirm --needed \
        plasma-meta \
        sddm \
    &> /dev/null

    sudo systemctl enable sddm.service &> /dev/null
}

packages() {
    echo "--> Install packages."
    sudo pacman -S --noconfirm --needed \
        ark \
        alacritty \
        arduino-cli \
        dolphin \
        elisa \
        firefox \
        gwenview \
        hunspell-en_us \
        hunspell-es_es \
        kate \
        kbackup \
        kcalc \
        kcolorchooser \
        kicad \
        ktorrent \
        nicotine+ \
        openvpn \
        okular \
        partitionmanager \
        spectacle \
        thunderbird \
        virtualbox \
        wl-clipboard \
    &> /dev/null
}

yay_install() {
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

        mkdir -p $tmp

        if [[ ! "${tmp}" || ! -d "${tmp}" ]]; then
            echo "Could not find ${tmp} dir"
            exit 1
        fi

        cd $tmp
        git clone https://aur.archlinux.org/yay.git &> /dev/null
        cd yay
        makepkg -sif --noconfirm &> /dev/null
    fi
}

yay_packages() {
    echo "--> Install yay packages."
    yay -Sy --noconfirm --needed \
        aws-cli-v2                 `#AWS CLI`            \
        aws-session-manager-plugin `#AWS CLI SSM Plugin` \
        ivpn-ui                    `#VPN Client`         \
        freetube                   `#YouTube player`     \
        tio                        `#Serial client`      \
        vscodium-bin               `#VS Code`            \
        slack-desktop              `#Slack`              \
        google-chrome              `#Google Chrome`      \
    &> /dev/null
}

printing() {
    echo "--> Install printing system."
    sudo pacman -S --noconfirm --needed \
        cups                  `#Printing system` \
        system-config-printer `#Print settings`  \
    &> /dev/null

    sudo systemctl start cups.service &> /dev/null
    sudo systemctl enable cups.service &> /dev/null
}

docker() {
    echo "--> Install docker."
    if ! type "docker" > /dev/null; then
        sudo pacman -S docker docker-compose --noconfirm --needed &> /dev/null
        sudo systemctl start docker.service &> /dev/null
        sudo systemctl enable docker.service &> /dev/null
        sudo usermod -aG docker $USER &> /dev/null
    fi
}

finish(){
    echo "--> Optional, please type: reboot"
    echo "    To use KDE only if out of desktop environment."
}

main "$@"
