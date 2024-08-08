#!/usr/bin/env bash
# set -eu

declare VOLUMEN;
declare PASSWORD;

main() {
    VOLUMEN="/dev/sda"

    ntp
    mirror
    keyboard
    user_password
    partitioning
    base
    configure
#     finish
}

ntp() {
    echo "--> Configure time zone and NTP."
    timedatectl set-timezone Europe/Madrid
    timedatectl set-ntp true
    hwclock --systohc
}

mirror() {
    echo "--> Configure mirrorlist."
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    reflector -a 48 -c ES -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
    echo "--> Synchronize database..."
    pacman -Sy &> /dev/null
}

keyboard() {
    echo "--> Configure keyboard layaout."
    loadkeys us
}

user_password() {
    echo "--> Define password for root and user."
    while true; do
        IFS="" read -s -p "    Enter your password: " PASSWORD </dev/tty
        echo
        IFS="" read -s -p "    Confirm your password: " password_confirm </dev/tty
        echo
        [ "${PASSWORD}" = "${password_confirm}" ] && break
        echo "--> Passwords do not match. Please try again."
    done
}

partitioning() {
    echo "--> Umount partitions."
    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true

    echo "--> Delete old partitions."
    (parted --script $VOLUMEN rm 1 &> /dev/null) || true
    (parted --script $VOLUMEN rm 2 &> /dev/null) || true
    (parted --script $VOLUMEN rm 3 &> /dev/null) || true

    echo "--> Create new partitions."
    parted --script $VOLUMEN mklabel gpt
    parted --script $VOLUMEN mkpart efi fat32 1MiB 1024MiB
    parted --script $VOLUMEN set 1 esp on
    parted --script $VOLUMEN mkpart swap linux-swap 1GiB 3GiB
    parted --script $VOLUMEN mkpart root ext4 3GiB 100%

    echo "--> Format partitions..."
    mkfs.fat -F32 -n UEFI "${VOLUMEN}1" &> /dev/null
    mkswap -L SWAP "${VOLUMEN}2" &> /dev/null
    mkfs.ext4 -L ROOT "${VOLUMEN}3" &> /dev/null

    echo "--> Verify partitions."
    partprobe /dev/sda

    echo "--> Mount: swap, root and boot"
    swapon "${VOLUMEN}2"
    mount "${VOLUMEN}3" /mnt
    mkdir -p /mnt/boot/efi/
    mount "${VOLUMEN}1" /mnt/boot/efi/

    echo "--> Remove default directories lost+found."
    rm -rf /mnt/boot/efi/lost+found
    rm -rf /mnt/lost+found

    echo "--> Generate fstab."
    mkdir /mnt/etc/
    genfstab -pU /mnt >> /mnt/etc/fstab
}

base() {
    echo "--> Installing essential packages..."
    pacstrap /mnt \
        base \
        base-devel \
        linux \
        linux-headers \
        linux-firmware \
        mkinitcpio \
        dhcpcd \
        networkmanager \
        iwd \
        grub \
        efibootmgr \
        vim \
        openssh \
    &> /dev/null
}

configure() {
    echo "--> Localization."
    echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
    echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
    echo "LANGUAGE=en_US" >> /mnt/etc/locale.conf
    echo "LC_ALL=C" >> /mnt/etc/locale.conf
    arch-chroot /mnt locale-gen &> /dev/null

    echo "--> Network configuration."
    echo "ws" > /mnt/etc/hostname

    cat << EOF > /mnt/etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   ws.localdomain ws
EOF

    echo "--> Create user."
    arch-chroot /mnt useradd --create-home --shell=/bin/bash --groups=wheel,uucp --password=$PASSWORD --comment="Nicola Strappazzon" ns
    arch-chroot /mnt sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

    echo "--> Install bootloader."
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB &> /dev/null
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null
}

finish(){
    echo "--> Unmount all partitions and reboot."
    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true
    reboot
}

main "$@"
