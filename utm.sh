#!/usr/bin/env bash
# set -eu

function main() {
    USERCOMMENT="Nicola Strappazzon C."
    USERNAME="nicola"
    HOSTNAME="strappazzon"

    # hay que hacer login al root con su - y la clave es root.

    configure_basic
    configure_locale
    user_password
    configure_user
    configure_network
    configure_input
    configure_environment
    configure_profile

    pacman -Syu
}

function configure_basic() {
    echo "--> Basic configure before install."

    # Configure time zone and NTP:
    timedatectl set-timezone Europe/Madrid
    timedatectl set-ntp true
    hwclock --systohc

    # Synchronize database:
    pacman -Syu &> /dev/null

    # Configure keyboard layaout:
    loadkeys us
}

function configure_locale() {
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    echo "LANGUAGE=en_US" >> /etc/locale.conf
    echo "LC_ALL=C" >> /etc/locale.conf
    locale-gen &> /dev/null
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

function configure_user() {
    echo "--> Create user."
    useradd --create-home --shell=/bin/bash --gid=users --groups=wheel,uucp,video --password="$PASSWORD" --comment="$USERCOMMENT" "$USERNAME"
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

    cp /etc/skel/.bashrc /root/.bashrc
    chmod 0600 /root/.bashrc
    usermod --shell /bin/bash root
    printf "root:%s" "$PASSWORD" | chpasswd --encrypted
}

function configure_network() {
    echo "--> Network configuration."
    echo "${HOSTNAME}" > /etc/hostname

    cat << EOF > /etc/hosts
::1         localhost
127.0.1.1   localhost ${HOSTNAME}.local ${HOSTNAME}.localdomain $HOSTNAME
EOF
}

function configure_input() {
    sed -i 's/#set bell-style none/set bell-style none/g' /mnt/etc/inputrc
}

function configure_environment() {
    cat > /etc/environment << 'EOF'
EDITOR=vim
TERM=xterm
TERMINAL=xterm
EOF
}

function configure_profile() {
    cat > /etc/skel/.bashrc << 'EOF'
[[ $- != *i* ]] && return

if [ -x /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -f "$i" ]; then
      . "$i"
    fi
  done
fi
EOF

    cat > /etc/profile.d/custom.sh << 'EOF'
#!/bin/sh

if [ -x ~/.bashrc.d ]; then
  for i in ~/.bashrc.d/*.sh; do
    if [ -f "$i" ]; then
      . "$i"
    fi
  done
fi
EOF

    cat > /etc/profile.d/ps.sh << 'EOF'
#!/bin/sh

if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
else
    PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
fi
EOF

    rm -f /etc/profile.d/perlbin.*
}
