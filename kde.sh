#!/usr/bin/env bash
# set -eu

function main() {
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

function update() {
    sudo pacman -Sy &> /dev/null
}

function ntp() {
    echo "--> Configure time zone and NTP."
    sudo timedatectl set-timezone Europe/Madrid
    sudo timedatectl set-ntp true
    sudo hwclock --systohc
}

function wakeup() {
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

function hibernation() {
    echo "--> Configure hibernation ."

    cat << EOF | sudo tee /etc/systemd/sleep.conf &> /dev/null
[Sleep]
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
EOF
}

function desktop() {
    echo "--> Install desktop."
    sudo pacman -S --noconfirm --needed \
        plasma-meta \
        sddm \
    &> /dev/null

    sudo systemctl enable sddm.service &> /dev/null
}

function packages() {
    echo "--> Install packages."
    sudo pacman -S --noconfirm --needed \
        alacritty        `#Terminal client`            \
        ark              `#Archiving Tool`             \
        dolphin          `#File manager`               \
        elisa            `#Music player`               \
        firefox          `#Web browser`                \
        gwenview         `#Image viewer`               \
        hunspell-en_us   `#Spell dictionary EN`        \
        hunspell-es_es   `#Spell dictionary ES`        \
        kamoso           `#Camera tool`                \
        kate             `#Code editor`                \
        kbackup          `#Backup tool`                \
        kcalc            `#Calculator`                 \
        kcharselect      `#select special characters`  \
        kcolorchooser    `#color palette tool`         \
        kfind            `#Find files`                 \
        kid3             `#Audio tag editor`           \
        ksystemlog       `#show all logs`              \
        ktorrent         `#Torrent client`             \
        nicotine+        `#Soulseek client`            \
        okteta           `#Hex editor`                 \
        okular           `#Document viewer`            \
        partitionmanager `#Partition Manager`          \
        powerdevil       `#Power consumption settings` \
        qtpass           `#GUI for pass`               \
        rssguard         `#RSS Client`                 \
        shellcheck       `#Shell linter`               \
        spectacle        `#Screenshots`                \
        thunderbird      `#Email client`               \
    &> /dev/null
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

function yay_packages() {
    echo "--> Install yay packages."
    yay -Sy --noconfirm --needed \
        freetube       `#YouTube player` \
        google-chrome  `#Google Chrome`  \
        ivpn-ui        `#VPN Client`     \
    &> /dev/null
}

function printing() {
    echo "--> Install printing system."
    sudo pacman -S --noconfirm --needed \
        cups                  `#Printing system`               \
        system-config-printer `#Print settings`                \
        hplip                 `#hp linux imaging and printing` \
    &> /dev/null

    sudo systemctl start cups.service &> /dev/null
    sudo systemctl enable cups.service &> /dev/null
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

function finish() {
    echo "--> Optional, please type: reboot"
    echo "    To use KDE only if out of desktop environment."
}

main "$@"
