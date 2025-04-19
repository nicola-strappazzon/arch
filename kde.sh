#!/usr/bin/env bash
# set -eu

function main() {
    update
    desktop
    packages
    configure
    finish
}

function update() {
    sudo pacman -Sy &> /dev/null
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
        ark                   `# Archiving Tool`             \
        digikam               `# Digital photo management`   \
        dolphin               `# File manager`               \
        elisa                 `# Music player`               \
        firefox               `# Web browser`                \
        gwenview              `# Image viewer`               \
        hunspell-en_us        `# Spell dictionary EN`        \
        hunspell-es_es        `# Spell dictionary ES`        \
        kamoso                `# Camera tool`                \
        kate                  `# Code editor`                \
        kbackup               `# Backup tool`                \
        kcalc                 `# Calculator`                 \
        kcharselect           `# Select special characters`  \
        kcolorchooser         `# color palette tool`         \
        kfind                 `# Find files`                 \
        kid3                  `# Audio tag editor`           \
        kmix                  `# Sound channel mixer`        \
        konsole               `# Terminal client`            \
        ksystemlog            `# Show all logs`              \
        ktorrent              `# Torrent client`             \
        okteta                `# Hex editor`                 \
        okular                `# Document viewer`            \
        partitionmanager      `# Partition Manager`          \
        powerdevil            `# Power consumption settings` \
        rssguard              `# RSS Client`                 \
        spectacle             `# Screenshots`                \
        system-config-printer `# Print settings`             \
        thunderbird           `# Email client`               \
    &> /dev/null
}

function configure() {
    echo "--> Configure KDE."
    kwriteconfig6 --file "$HOME"/.config/kdeglobals --group "General" --key "ColorSchemeHash" "babca25f3a5cf7ece26a85de212ab43d0a141257"
    kwriteconfig6 --file "$HOME"/.config/kdeglobals --group "KDE" --key "LookAndFeelPackage" "org.kde.breezedark.desktop"
    kwriteconfig6 --file "$HOME"/.config/kdeglobals --group "KDE" --key "widgetStyle" "Fusion"
    kwriteconfig6 --file "$HOME"/.config/kdeglobals --group "Sounds" --key "Enable" "false"
    kwriteconfig6 --file "$HOME"/.config/ksplashrc --group "KSplash" --key "Engine" "None"
    kwriteconfig6 --file "$HOME"/.config/ksplashrc --group "KSplash" --key "Theme" "None"
    kwriteconfig6 --file "$HOME"/.config/kwalletrc --group "Wallet" --key "Enabled" "false"
    kwriteconfig6 --file "$HOME"/.config/kwinrc --group "TabBoxAlternative" --key "HighlightWindows" "false"
    kwriteconfig6 --file "$HOME"/.config/kwinrc --group "TabBoxAlternative" --key "LayoutName" "compact"
    kwriteconfig6 --file "$HOME"/.config/kwinrc --group "TabBox" --key "HighlightWindows" "false"
    kwriteconfig6 --file "$HOME"/.config/plasma-localerc --group "Formats" --key "LANG" "en_US.UTF-8"
    kwriteconfig6 --file "$HOME"/.config/plasmanotifyrc --group "DoNotDisturb" --key "NotificationSoundsMuted" "true"
    kwriteconfig6 --file "$HOME"/.config/kglobalshortcutsrc --group "services" --group "org.kde.spectacle.desktop" --key "RectangularRegionScreenShot" "Print"
    kscreen-doctor output.HDMI-A-1.scale.1 &> /dev/null
    kscreen-doctor output.HDMI-A-1.mode.2560x1440@60 &> /dev/null

    cat << EOF | sudo tee /etc/sddm.conf.d/kde_settings.conf &> /dev/null
[Autologin]
Relogin=false
Session=
User=

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Theme]
Current=breeze

[Users]
MaximumUid=60513
MinimumUid=1000
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/breeze/theme.conf.user &> /dev/null
[General]
background=/usr/share/wallpapers/Mountain/contents/images_dark/5120x2880.png
showClock=true
type=image
EOF
}

function finish() {
    echo "--> Optional, please type: reboot"
    echo "    To use KDE only if out of desktop environment."
}

main "$@"
