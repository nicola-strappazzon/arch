#!/usr/bin/env bash
# set -eu

declare HOSTNAME;
declare PASSWORD_USER;
declare PASSWORD_VOLUMEN;
declare VOLUMEN;
declare VOLUMEN_ID;

function main() {
    USERCOMMENT="Nicola Strappazzon C."
    USERNAME="nicola"
    HOSTNAME="strappazzon"

    configure_basic
    user_password
    volumen_password
    partitioning
    install_base
    install_microcode
    configure_input
    configure_locale
    configure_environment
    configure_profile
    configure_network
    configure_user
    configure_grub
    configure_ntp
    configure_wakeup
    # packages
    # drivers
    # services
    # finish
}

function configure_basic() {
    echo "==> Basic configure before install."

    # Configure time zone and NTP:
    timedatectl set-timezone Europe/Madrid
    timedatectl set-ntp true
    hwclock --systohc

    # Configure mirrorlist:
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
    reflector \
      --protocol https \
      --latest 20 \
      --number 10 \
      --sort score \
      --download-timeout 10 \
      --save /etc/pacman.d/mirrorlist

    # Synchronize database:
    pacman -Sy &> /dev/null

    # Configure keyboard layaout:
    loadkeys us
}

function user_password() {
    local confirm
    echo "==> Set password for root and the user account."
    while true; do
        IFS="" read -r -s -p "    Enter your password: " PASSWORD_USER </dev/tty
        echo
        IFS="" read -r -s -p "    Confirm your password: " confirm </dev/tty
        echo

        if [ -z "$PASSWORD_USER" ]; then
            echo "==> Password cannot be empty."
            continue
        fi

        if [ "$PASSWORD_USER" = "$confirm" ]; then
            break
        fi

        echo "==> Passwords do not match. Please try again."
    done
    PASSWORD_USER=$(openssl passwd -6 "$confirm")
}

function volumen_password() {
    local confirm
    echo "==> Set password for the encrypted disk."
    while true; do
        IFS="" read -r -s -p "    Enter your password: " PASSWORD_VOLUMEN </dev/tty
        echo
        IFS="" read -r -s -p "    Confirm your password: " confirm </dev/tty
        echo

        if [ -z "$PASSWORD_VOLUMEN" ]; then
            echo "==> Password cannot be empty."
            continue
        fi

        if [ "$PASSWORD_VOLUMEN" = "$confirm" ]; then
            break
        fi

        echo "==> Passwords do not match. Please try again."
    done
}

function partitioning() {
    readarray -t VOLUMES_LIST < <(lsblk --list --nodeps --ascii --noheadings --output=NAME --filter 'TYPE=="disk" && SIZE > 0' | sort)

    echo "==> Available volumes:"
    for VOLUMEN_INDEX in "${!VOLUMES_LIST[@]}"; do
        name="${VOLUMES_LIST[$VOLUMEN_INDEX]}"
        size=$(lsblk --nodeps --noheadings --output=SIZE "/dev/$name")
        model=$(lsblk --nodeps --noheadings --output=MODEL "/dev/$name")
        printf "    %d) %s (%s)\n" "$((VOLUMEN_INDEX+1))" "$model" "$(ltrim "$size")"
    done

    VOLUMENS_COUNT=${#VOLUMES_LIST[@]}

    until [[ $VOLUMEN_ID =~ ^[1-9][0-9]*$ ]] && (( VOLUMEN_ID <= VOLUMENS_COUNT )); do
        IFS="" read -r -p "--> Choice volume number: " VOLUMEN_ID </dev/tty
    done

    VOLUMEN="/dev/${VOLUMES_LIST[$((VOLUMEN_ID-1))]}"

    echo "--> Has chosen this volume: $VOLUMEN"

    echo "==> Partitioning and format volume."
    # Umount partitions:
    umount --quiet --recursive /mnt/boot/efi 2>/dev/null || true
    umount --quiet --recursive /mnt 2>/dev/null || true
    swapoff --all 2>/dev/null || true
    cryptsetup close cryptroot 2>/dev/null || true
    udevadm settle

    # Delete all partitions:
    wipefs --all --force --quiet "${VOLUMEN}"
    sgdisk --zap-all "${VOLUMEN}" &>/dev/null || true

    # Create new partitions:
    parted --script "${VOLUMEN}" mklabel gpt
    parted --script "${VOLUMEN}" mkpart efi fat32 1MiB 1024MiB
    parted --script "${VOLUMEN}" set 1 esp on
    parted --script "${VOLUMEN}" mkpart swap linux-swap 1GiB 32GiB
    parted --script "${VOLUMEN}" mkpart root ext4 32GiB 100%

    # Verify partitions:
    partprobe "${VOLUMEN}"
    udevadm settle

    DISK=$(basename "$VOLUMEN")
    UEFI=$(lsblk --ascii --noheadings --output=PATH --filter "PARTLABEL=='efi'  && PKNAME=='$DISK'")
    SWAP=$(lsblk --ascii --noheadings --output=PATH --filter "PARTLABEL=='swap' && PKNAME=='$DISK'")
    ROOT=$(lsblk --ascii --noheadings --output=PATH --filter "PARTLABEL=='root' && PKNAME=='$DISK'")

    if [[ -z "$UEFI" || -z "$SWAP" || -z "$ROOT" ]]; then
        echo "ERROR: Partition detection failed"
        lsblk -o NAME,PARTLABEL,SIZE
        exit 1
    fi

    # Format partitions:
    mkfs.fat -F32 -n UEFI "${UEFI}" &> /dev/null
    mkswap -L SWAP "${SWAP}" &> /dev/null

    # Encrypt disk
    printf "%s" "$PASSWORD_VOLUMEN" | cryptsetup luksFormat --type luks2 --batch-mode --key-file - "$ROOT"
    printf "%s" "$PASSWORD_VOLUMEN" | cryptsetup open --key-file - "$ROOT" cryptroot
    udevadm settle
    mkfs.ext4 -L ROOT "/dev/mapper/cryptroot" &> /dev/null

    # Mount: swap, root and boot:
    swapon "${SWAP}"
    mount "/dev/mapper/cryptroot" /mnt
    mkdir -p /mnt/boot/efi/
    mount "${UEFI}" /mnt/boot/efi/

    # Remove default directories lost+found:
    rm -rf /mnt/boot/efi/lost+found
    rm -rf /mnt/lost+found

    # Generate fstab:
    mkdir -p /mnt/etc/
    genfstab -pU /mnt >> /mnt/etc/fstab
}

function install_base() {
    echo "==> Installing essential packages."
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

function install_microcode() {
    echo "==> Installing CPU microcode."

    if grep -q AuthenticAMD /proc/cpuinfo; then
        pacstrap /mnt amd-ucode &> /dev/null
    elif grep -q GenuineIntel /proc/cpuinfo; then
        pacstrap /mnt intel-ucode &> /dev/null
    fi
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
    echo "==> Network configuration."
    echo $HOSTNAME > /mnt/etc/hostname

    cat << EOF > /mnt/etc/hosts
::1         localhost
127.0.1.1   localhost ${HOSTNAME}.local ${HOSTNAME}.localdomain $HOSTNAME
EOF
}

function configure_user() {
    echo "==> Create user."
    arch-chroot /mnt useradd --create-home --shell=/bin/bash --gid=users --groups=wheel,uucp,video --password="$PASSWORD_USER" --comment="$USERCOMMENT" "$USERNAME"
    arch-chroot /mnt sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

    cp /mnt/etc/skel/.bashrc /mnt/root/.bashrc
    chmod 0600 /mnt/root/.bashrc
    arch-chroot /mnt usermod --shell /bin/bash root
    printf "root:%s" "$PASSWORD_USER" | arch-chroot /mnt chpasswd --encrypted
}

function configure_grub() {
    echo "==> Install and configure bootloader."
    ROOT_UUID=$(blkid -s UUID -o value "$ROOT")

    # Configure kernel parameters for LUKS
    echo 'GRUB_ENABLE_CRYPTODISK=y' >> /mnt/etc/default/grub
    sed -i "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${ROOT_UUID}:cryptroot root=/dev/mapper/cryptroot\"|" /mnt/etc/default/grub
    # Enable encrypt hook
    sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt filesystems fsck)/' /mnt/etc/mkinitcpio.conf

    arch-chroot /mnt mkinitcpio -P &> /dev/null
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

function configure_ntp() {
    echo "==> Configure time zone and NTP."
    arch-chroot /mnt timedatectl set-timezone Europe/Madrid
    arch-chroot /mnt timedatectl set-ntp true
    arch-chroot /mnt hwclock --systohc
}

function configure_wakeup() {
    echo "==> Configure wakeup."

    cat << EOF | sudo tee /mnt/usr/local/bin/wakeup-disable.sh &> /dev/null
#!/usr/bin/env sh
# set -eu

/bin/echo XHC0 > /proc/acpi/wakeup
/bin/echo XHC1 > /proc/acpi/wakeup
/bin/echo GPP0 > /proc/acpi/wakeup
EOF

    cat << EOF | sudo tee /mnt/etc/systemd/system/wakeup-disable.service &> /dev/null
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

    arch-chroot /mnt chmod +x /usr/local/bin/wakeup-disable.sh
    arch-chroot /mnt systemctl enable wakeup-disable.service &> /dev/null
    arch-chroot /mnt systemctl start wakeup-disable.service &> /dev/null
}

function configure_hibernation() {
    echo "==> Configure hibernation ."

    cat << EOF | sudo tee /mnt/etc/systemd/sleep.conf &> /dev/null
[Sleep]
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
EOF
}

function packages() {
    echo "==> Install aditional packages."
    PACKAGES=(
        bash-completion
        bind-tools
        btop
        ca-certificates
        curl
        dosfstools
        foomatic-db
        foomatic-db-engine
        foomatic-db-ppds
        fzf
        ghostscript
        git
        go
        gsfonts
        hplip
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
        arch-chroot /mnt pacman --sync --noconfirm --needed "${PACKAGE}" &> /dev/null
    done
}

function drivers() {
    echo "==> Install drivers."
    arch-chroot /mnt pacman --sync --noconfirm --needed \
        alsa-firmware \
        alsa-utils \
        pulseaudio \
        pulseaudio-alsa \
        pipewire \
        pipewire-alsa \
        ddcutil \
    &> /dev/null
}

function services() {
    echo "==> Enable services."
    arch-chroot /mnt systemctl enable NetworkManager &> /dev/null
    arch-chroot /mnt systemctl enable sshd &> /dev/null
    arch-chroot /mnt systemctl start NetworkManager &> /dev/null
    arch-chroot /mnt systemctl start sshd &> /dev/null
}

function finish() {
    echo "==> Install process is finished."
    echo
    read -n 1 -s -r -p "Please remove the installation medium and press any KEY to reboot or press Ctrl+C to cancel" </dev/tty

    (umount --all-targets --quiet --recursive /mnt/) || true
    (swapoff --all) || true
    clear
    reboot
}

function ltrim() {
    local s="$*"
    printf "%s" "${s#"${s%%[![:space:]]*}"}"
}

main "$@"
