#!/usr/bin/env sh
set -eu

declare VOLUMEN;
declare ENCRYPTED_PASSWORD;
declare -I EXITCODE=0;

main() {
    VOLUMEN="/dev/sda"

    ntp
    mirror
    keyboard
    user_password
    partitioning
    base
    chroot
    finish
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
    loadkeys us
}

user_password(){
    while true; do
        read -s -p "Enter your password: " password
        echo
        read -s -p "Confirm your password: " password_confirm
        echo
        [ "$password" = "$password_confirm" ] && break
        echo "Passwords do not match. Please try again."
    done

    ENCRYPTED_PASSWORD=$(openssl passwd -6 "$password")
}

partitioning() {
    echo "--> Umount partitions."
    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true

    echo "--> Delete old partitions."
    (parted --script $VOLUMEN rm 1) || true
    (parted --script $VOLUMEN rm 2) || true
    (parted --script $VOLUMEN rm 3) || true

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

chroot() {
    arch-chroot /mnt /bin/bash <<EOF
# Localization
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "LANGUAGE=en_US" >> /etc/locale.conf
echo "LC_ALL=C" >> /etc/locale.conf
locale-gen

# Network configuration
echo "ws" > /etc/hostname

cat << EOL > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   ws.localdomain ws
EOL

# Create user
echo "root:${ENCRYPTED_PASSWORD}" | chpasswd -e
useradd -m -g users -G wheel -s /bin/bash ns
usermod -a -G uucp ns
echo "ns:${ENCRYPTED_PASSWORD}" | chpasswd -e
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Install bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

EOF
}

finish(){
    echo "--> Unmount all partitions and reboot."
    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true
    reboot
}

main "$@"
