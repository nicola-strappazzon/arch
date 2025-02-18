#!/usr/bin/env bash
# set -eu

main() {
    update
    ntp
    wakeup
    hibernation
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

wakeup() {
    echo "--> Configure wakeup."

    cat << EOF | sudo tee /usr/local/bin/wakeup-disable.sh &> /dev/null
#!/usr/bin/env sh
# set -eu

/bin/echo XHC0 > /proc/acpi/wakeup
/bin/echo XHC1 > /proc/acpi/wakeup
/bin/echo GPP0 > /proc/acpi/wakeup
EOF

    cat << EOF | sudo tee /etc/systemd/system/wakeup-disable.service &> /dev/null
[Unit]
Description=Fix suspend by disabling XHC0, XHC1 and GPP0 sleepstate thingie
After=systemd-user-sessions.service plymouth-quit-wait.service
After=rc-local.service
Before=getty.target
IgnoreOnIsolate=yes

[Service]
Type=oneshot
ExecStart=/usr/local/bin/wakeup-disable.sh
RemainAfterExit=true

[Install]
WantedBy=basic.target
EOF

    sudo chmod +x /usr/local/bin/wakeup-disable.sh
    sudo systemctl enable wakeup-disable.service &> /dev/null
    sudo systemctl start wakeup-disable.service &> /dev/null
}

hibernation() {
    echo "--> Configure hibernation ."

    cat << EOF | sudo tee /etc/systemd/sleep.conf &> /dev/null
[Sleep]
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
EOF
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
        alacritty   `#Terminal client` \
        arduino-cli `#Arduino cli`     \
        ark         `#Archiving Tool`  \
        dolphin     `#File manager`    \
        elisa       `#Music player`    \
        firefox     `#Web browser`     \
        gwenview \
        helm \
        hunspell-en_us \
        hunspell-es_es \
        kamoso \
        kate \
        kbackup \
        kcalc \
        kcharselect \
        kcolorchooser \
        kicad \
        ktorrent \
        minikube \
        nicotine+ \
        okular \
        openvpn \
        partitionmanager \
        percona-toolkit \
        rssguard \
        shellcheck \
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

yay_packages() {
    echo "--> Install yay packages."
    yay -Sy --noconfirm --needed \
        aws-cli-v2                 `#AWS CLI`             \
        aws-session-manager-plugin `#AWS CLI SSM Plugin`  \
        freetube                   `#YouTube player`      \
        google-chrome              `#Google Chrome`       \
        ivpn-ui                    `#VPN Client`          \
        slack-desktop              `#Slack`               \
        sql-workbench              `#SQL Client`          \
        tio                        `#Serial client`       \
        vscodium-bin               `#VS Code`             \
        zoom                       `#Zoom meeting client` \
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
        sudo usermod -aG docker "$USER" &> /dev/null
    fi
}

finish(){
    echo "--> Optional, please type: reboot"
    echo "    To use KDE only if out of desktop environment."
}

main "$@"
