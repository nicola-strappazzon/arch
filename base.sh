#!/usr/bin/env bash
# set -eu

declare VOLUMEN;
declare VOLUMEN_ID;
declare HOSTNAME;
declare PASSWORD;

function main() {
    VOLUMEN="/dev/nvme0n1"
    HOSTNAME="strappazzon"

    ntp
    mirror
    keyboard
    user_password
    partitioning
    base
    configure_input
    configure_locale
    configure_environment
    configure_profile
    configure_network
    configure_user
    configure_grub
    packages
    services
    drivers
    finish
}

function ntp() {
    echo "--> Configure time zone and NTP."
    timedatectl set-timezone Europe/Madrid
    timedatectl set-ntp true
    hwclock --systohc
}

function mirror() {
    echo "--> Configure mirrorlist."
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    reflector -a 48 -c ES -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
    echo "--> Synchronize database..."
    pacman -Sy &> /dev/null
}

function keyboard() {
    echo "--> Configure keyboard layaout."
    loadkeys us
}

function user_password() {
    echo "--> Define password for root and user."
    while true; do
        IFS="" read -r -s -p "    Enter your password: " PASSWORD </dev/tty
        echo
        IFS="" read -r -s -p "    Confirm your password: " password_confirm </dev/tty
        echo
        [ "${PASSWORD}" = "${password_confirm}" ] && break
        echo "--> Passwords do not match. Please try again."
    done
    PASSWORD=$(openssl passwd -6 "$password_confirm")
}

function partitioning() {
    readarray -t VOLUMES_LIST < <(lsblk --list --nvme --nodeps --ascii --noheadings --output=NAME | sort)
    VOLUMENS_COUNT=$(( ${#VOLUMES_LIST[@]} - 1 ))

    echo "--> Available volumes:"
    for VOLUMEN_INDEX in "${!VOLUMES_LIST[@]}"; do
        echo "    ${VOLUMEN_INDEX}. ${VOLUMES_LIST[$VOLUMEN_INDEX]}"
    done

    until [[ $VOLUMEN_ID =~ ^[0-${VOLUMENS_COUNT}]$ ]]; do
        IFS="" read -r -p "  > Choice volume number: " VOLUMEN_ID </dev/tty
    done

    VOLUMEN="/dev/${VOLUMES_LIST[$VOLUMEN_ID]}"
    echo "  > Has chosen this volume: $VOLUMEN"

    echo "--> Umount partitions."
    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true

    echo "--> Delete old partitions."
    (parted --script "${VOLUMEN}" rm 1 &> /dev/null) || true
    (parted --script "${VOLUMEN}" rm 2 &> /dev/null) || true
    (parted --script "${VOLUMEN}" rm 3 &> /dev/null) || true

    echo "--> Create new partitions."
    parted --script "${VOLUMEN}" mklabel gpt
    parted --script "${VOLUMEN}" mkpart efi fat32 1MiB 1024MiB
    parted --script "${VOLUMEN}" set 1 esp on
    parted --script "${VOLUMEN}" mkpart swap linux-swap 1GiB 32GiB
    parted --script "${VOLUMEN}" mkpart root ext4 32GiB 100%

    echo "--> Format partitions."
    mkfs.fat -F32 -n UEFI "${VOLUMEN}p1" &> /dev/null
    mkswap -L SWAP "${VOLUMEN}p2" &> /dev/null
    mkfs.ext4 -L ROOT "${VOLUMEN}p3" &> /dev/null

    echo "--> Verify partitions."
    partprobe "${VOLUMEN}"

    echo "--> Mount: swap, root and boot"
    swapon "${VOLUMEN}p2"
    mount "${VOLUMEN}p3" /mnt
    mkdir -p /mnt/boot/efi/
    mount "${VOLUMEN}p1" /mnt/boot/efi/

    echo "--> Remove default directories lost+found."
    rm -rf /mnt/boot/efi/lost+found
    rm -rf /mnt/lost+found

    echo "--> Generate fstab."
    mkdir /mnt/etc/
    genfstab -pU /mnt >> /mnt/etc/fstab
}

function base() {
    echo "--> Installing essential packages."
    pacstrap /mnt \
        base \
        base-devel \
        dhcpcd \
        efibootmgr \
        grub \
        iwd \
        linux \
        linux-firmware \
        linux-headers \
        man-db \
        mkinitcpio \
        networkmanager \
        openssh \
        vim \
    &> /dev/null
}

function configure_input() {
    sed -i 's/#set bell-style none/set bell-style none/g' /mnt/etc/inputrc
}

function configure_locale() {
    echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
    echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
    echo "LANGUAGE=en_US" >> /mnt/etc/locale.conf
    echo "LC_ALL=C" >> /mnt/etc/locale.conf
    arch-chroot /mnt locale-gen &> /dev/null
}

function configure_environment() {
    cat > /mnt/etc/environment << 'EOF'
EDITOR=vim
TERM=xterm
TERMINAL=xterm
EOF
}

function configure_profile() {
    cat > /mnt/etc/skel/.bashrc << 'EOF'
[[ $- != *i* ]] && return

if [ -x /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -f "$i" ]; then
      . "$i"
    fi
  done
fi
EOF

    cat > /mnt/etc/profile.d/custom.sh << 'EOF'
#!/bin/sh

if [ -x ~/.bashrc.d ]; then
  for i in ~/.bashrc.d/*.sh; do
    if [ -f "$i" ]; then
      . "$i"
    fi
  done
fi
EOF

    cat > /mnt/etc/profile.d/ps.sh << 'EOF'
#!/bin/sh

if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
else
    PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
fi
EOF

    rm -f /mnt/etc/profile.d/perlbin.*
}

function configure_network() {
    echo "--> Network configuration."
    echo $HOSTNAME > /mnt/etc/hostname

    cat << EOF > /mnt/etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain $HOSTNAME
EOF
}

function configure_user() {
    echo "--> Create user."
    arch-chroot /mnt useradd --create-home --shell=/bin/bash --gid=users --groups=wheel,uucp,video --password="$PASSWORD" --comment="Nicola Strappazzon C." nicola

    arch-chroot /mnt sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

    cp /mnt/etc/skel/.bashrc /mnt/root/.bashrc
    chmod 0600 /mnt/root/.bashrc
    arch-chroot /mnt usermod --shell /bin/bash root
    printf "root:%s" "$PASSWORD" | arch-chroot /mnt chpasswd --encrypted
}

function configure_grub() {
    echo "--> Install & configure bootloader."
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB &> /dev/null
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null

    echo "GRUB_DEFAULT=0" > /mnt/etc/default/grub.silent
    echo "GRUB_TIMEOUT=0" >> /mnt/etc/default/grub.silent
    echo "GRUB_RECORDFAIL_TIMEOUT=\$GRUB_TIMEOUT" >> /mnt/etc/default/grub.silent

    chmod 0644 /mnt/etc/default/grub.silent

    sed -i "s/timeout=5/timeout=0/" /mnt/boot/grub/grub.cfg
    sed -i "s/echo	'Loading Linux linux ...'//" /mnt/boot/grub/grub.cfg
    sed -i "s/echo	'Loading initial ramdisk ...'//" /mnt/boot/grub/grub.cfg
    sed -i "s/loglevel=3 quiet/quiet loglevel=0 rd.systemd.show_status=auto rd.udev.log_level=3/" /mnt/boot/grub/grub.cfg
}

function packages() {
    echo "--> Install aditional packages."
    PACKAGES=(
        base
        base-devel
        bash-completion
        bind-tools
        btop
        ca-certificates
        curl
        dosfstools
        fzf
        git
        go
        htop
        less
        libusb
        links
        neofetch
        net-tools
        networkmanager-openvpn
        nmap
        openvpn
        pass
        pass-otp
        rsync
        testdisk
        tmux
        traceroute
        ufw
        unrar
        unzip
        usbutils
        vim
        wget
        wl-clipboard
        xclip
    )

    for PACKAGE in "${PACKAGES[@]}"; do
        arch-chroot /mnt pacman -S "${PACKAGE}" --noconfirm --needed &> /dev/null
    done
}

function services() {
    echo "--> Enable services."
    arch-chroot /mnt systemctl enable sshd
    arch-chroot /mnt systemctl start sshd

    arch-chroot /mnt systemctl enable NetworkManager
    arch-chroot /mnt systemctl start NetworkManager
}

function drivers() {
    echo "--> Install drivers."
    sudo pacman -S --noconfirm --needed \
        alsa-firmware \
        alsa-utils \
        amd-ucode \
        pulseaudio \
        pulseaudio-alsa \
        ddcutil \
    &> /dev/null
}

function finish() {
    echo "--> Unmount all partitions and reboot."
    echo
    read -n 1 -s -r -p "Press any key to continue" </dev/tty

    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true
    clear
    reboot
}

main "$@"
