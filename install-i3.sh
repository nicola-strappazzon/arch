#!/usr/bin/env bash
# set -eu

main() {
#     drivers
#     xorg
#     fonts
#     desktop
#     display_manager
#     theme
#     launcher
#     packages
    yay
    yay_packages
    docker

#     configure_i3wm
#     configure_polybar
#     configure_xterm
#     configure_rofi
#     configure_feh
}

drivers() {
    sudo pacman -S --noconfirm --needed xf86-video-amdgpu
}

xorg() {
    sudo pacman -S --noconfirm --needed \
        xorg \
        xorg-server \
        xorg-xinit \
        xorg-fonts-misc \
        xorg-mkfontscale \
    &> /dev/null
}

fonts() {
    sudo pacman -S --noconfirm --needed \
        adobe-source-sans-fonts \
        noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        terminus-font \
        ttf-dejavu \
        ttf-droid \
        ttf-font-awesome \
        ttf-inconsolata \
        ttf-indic-otf \
        ttf-liberation \
        ttf-nerd-fonts-symbols \
    &> /dev/null

    fc-cache -f -v &> /dev/null
}

desktop() {
    sudo pacman -S --noconfirm --needed \
        i3-wm \
        polybar \
        feh `#Wallpaper tool`\
        xterm \
    &> /dev/null
}

theme() {
    sudo pacman -S --noconfirm --needed \
        lxappearance \
        materia-gtk-theme \
        papirus-icon-theme \
    &> /dev/null
}

display_manager() {
    sudo pacman -S --noconfirm --needed \
        sddm \
    &> /dev/null
    sudo systemctl enable sddm.service &> /dev/null
}

launcher() {
    sudo pacman -S --noconfirm --needed \
        rofi \
        rofi-calc \
        rofi-emoji \
        rofi-pass \
    &> /dev/null
}

packages() {
    sudo pacman -S --noconfirm --needed \
        cheese    `#Webcam GUI`   \
        evince    `#PDF viewer`   \
        firefox   `#WEB browser`  \
        flameshot `#Screenshot`   \
        mpv       `#Video player` \
        nemo      `#File manager` \
        rhythmbox `#Audio player` \
        viewnior  `#Image viewer` \
    &> /dev/null
}

yay() {
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

    if ! command yay &> /dev/null; then
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
    yay -Sy --noconfirm --needed \
        sublime-text \
    &> /dev/null
}

docker() {
    if ! type "docker" > /dev/null; then
        sudo pacman -S docker --noconfirm --needed
        sudo systemctl start docker.service
        sudo systemctl enable docker.service
        sudo newgrp docker
        sudo usermod -aG docker $USER
    fi
}

configure_i3wm() {
    mkdir -p /home/ns/.config/i3/
    cat > /home/ns/.config/i3/config << 'EOF'
exec --no-startup-id feh --no-fehbg --bg-fill '/home/ns/.config/feh/wallpaper.jpg'
exec_always --no-startup-id $HOME/.config/polybar/launch.sh

set $mod Mod4
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

font pango:monospace 10

bindsym $mod+Down focus down
bindsym $mod+Left focus left
bindsym $mod+Return exec xterm
bindsym $mod+Right focus right
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Right move right
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+c reload
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+q kill
bindsym $mod+Shift+r restart
bindsym $mod+Shift+semicolon move right
bindsym $mod+Shift+space floating toggle
bindsym $mod+Up focus up
bindsym $mod+a focus parent
bindsym $mod+e layout toggle split
bindsym $mod+f fullscreen toggle
bindsym $mod+h split h
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+r mode "resize"
bindsym $mod+s layout stacking
bindsym $mod+semicolon focus right
bindsym $mod+v split v
bindsym $mod+w layout tabbed

bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

floating_modifier $mod
tiling_drag modifier titlebar

bindsym $mod+space exec --no-startup-id rofi -config /home/ns/.config/rofi/config.rasi -show drun

client.focused #373B41 #282A2E #C5C8C6 #F0C674
gaps inner 4
gaps outer 2
EOF
}

configure_xterm() {
    cat > /home/ns/.Xdefaults << 'EOF'
XTerm*background: #002B36
XTerm*borderColor: #343434
XTerm*color0: #222222
XTerm*color10: #C4DF90
XTerm*color11: #FFE080
XTerm*color12: #B8DDEA
XTerm*color13: #C18FCB
XTerm*color14: #6bc1d0
XTerm*color15: #cdcdcd
XTerm*color1: #9E5641
XTerm*color2: #6C7E55
XTerm*color3: #CAAF2B
XTerm*color4: #7FB8D8
XTerm*color5: #956D9D
XTerm*color6: #4c8ea1
XTerm*color7: #808080
XTerm*color8: #454545
XTerm*color9: #CC896D
XTerm*cursorBlink: true
XTerm*cursorUnderLine: true
XTerm*faceName: Bitstream Vera Serif Mono
XTerm*foreground: #D2D2D2
XTerm*scrollBar: off
XTerm*selectToClipboard: true
XTerm*vt100*geometry: 88x24
xterm*eightBitInput: false
xterm*faceSize: 11
EOF
}

configure_polybar() {
    mkdir -p /home/ns/.config/polybar/
    touch /home/ns/.config/polybar/launch.sh
    chmod +x /home/ns/.config/polybar/launch.sh

    cat > /home/ns/.config/polybar/launch.sh << 'EOF'
#!/usr/bin/env bash

killall -q polybar
polybar --config=$HOME/.config/polybar/config.ini
EOF

    cat > /home/ns/.config/polybar/config.ini << 'EOF'
[colors]
background = #282A2E
background-alt = #373B41
foreground = #C5C8C6
primary = #F0C674
secondary = #8ABEB7
alert = #A54242
disabled = #707880

[bar/main]
width = 100%
height = 18pt
radius = 3
background = ${colors.background}
foreground = ${colors.foreground}
line-size = 3pt
border-size = 4pt
border-color = #00000000
padding-left = 0
padding-right = 1
module-margin = 1
separator = |
separator-foreground = ${colors.disabled}
font-0 = terminus:pixelsize=10;2
font-1 = "Symbols Nerd Font:style=Regular:pixelsize=8"
modules-left = xworkspaces xwindow
modules-right = filesystem pulseaudio xkeyboard memory cpu wlan eth date powermenu
cursor-click = pointer
cursor-scroll = ns-resize
enable-ipc = true

[module/systray]
type = internal/tray
format-margin = 8pt
tray-spacing = 16pt

[module/xworkspaces]
type = internal/xworkspaces
label-active = %name%
label-active-background = ${colors.background-alt}
label-active-underline= ${colors.primary}
label-active-padding = 1
label-occupied = %name%
label-occupied-padding = 1
label-urgent = %name%
label-urgent-background = ${colors.alert}
label-urgent-padding = 1
label-empty = %name%
label-empty-foreground = ${colors.disabled}
label-empty-padding = 1

[module/xwindow]
type = internal/xwindow
label = %title:0:60:...%

[module/filesystem]
type = internal/fs
interval = 25
mount-0 = /
label-mounted = %{F#F0C674}%mountpoint%%{F-} %percentage_used%%
label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.disabled}

[module/pulseaudio]
type = internal/pulseaudio
format-volume-prefix = "VOL "
format-volume-prefix-foreground = ${colors.primary}
format-volume = <label-volume>
label-volume = %percentage%%
label-muted = muted
label-muted-foreground = ${colors.disabled}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "RAM "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "CPU "
format-prefix-foreground = ${colors.primary}
label = %percentage:2%%

[module/date]
type = internal/date
interval = 1
date = %H:%M
date-alt = %Y-%m-%d %H:%M:%S
label = %date%
label-foreground = ${colors.primary}

[module/powermenu]
type = custom/menu
expand-right = true
format-spacing = 1

label-open = 
label-open-foreground = ${colors.secondary}
label-close = Cancel
label-close-foreground = ${colors.secondary}
label-separator = |

menu-0-0 = Reboot
menu-0-0-exec = reboot
menu-0-1 = Power off
menu-0-1-exec = poweroff
menu-0-2 = Hibernate
menu-0-2-exec = systemctl hibernate

[settings]
screenchange-reload = true
pseudo-transparency = true

[global/wm]
margin-top = 5
margin-bottom = 5
EOF
}

configure_rofi() {
    mkdir -p /home/ns/.config/rofi/

    cat > /home/ns/.config/rofi/config.rasi << 'EOF'
configuration {
 font: "Noto 10";
 combi-modes: "window,drun,ssh";
}
@theme "solarized"
EOF
}

configure_feh() {
    mkdir -p /home/ns/.config/feh/
    cp wallpaper/wallpaper.jpg /home/ns/.config/feh/wallpaper.jpg
}

main "$@"
