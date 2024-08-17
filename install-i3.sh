#!/usr/bin/env bash
# set -eu

main() {
    # drivers
    # xorg
    # fonts
    # desktop
    # display_manager
    # theme
    # launcher
    # packages
    # yay
    # yay_packages
    # docker

    configure_theme
    # configure_i3wm
    # configure_polybar
    # configure_xterm
    # configure_rofi
    # configure_feh
}

drivers() {
    echo "--> Install drivers."
    sudo pacman -S --noconfirm --needed xf86-video-amdgpu &> /dev/null
}

xorg() {
    echo "--> Install xorg."
    sudo pacman -S --noconfirm --needed \
        xorg \
        xorg-server \
        xorg-xinit \
        xorg-fonts-misc \
        xorg-mkfontscale \
    &> /dev/null
}

fonts() {
    echo "--> Install fonts."
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
    echo "--> Install desktop."
    sudo pacman -S --noconfirm --needed \
        i3-wm \
        polybar \
        feh `#Wallpaper tool`\
        xterm \
    &> /dev/null
}

theme() {
    echo "--> Install themes."
    sudo pacman -S --noconfirm --needed \
        lxappearance \
        materia-gtk-theme \
        papirus-icon-theme \
    &> /dev/null
}

display_manager() {
    echo "--> Install display manager."
    sudo pacman -S --noconfirm --needed \
        sddm \
        qt6-svg \
    &> /dev/null
    sudo systemctl enable sddm.service &> /dev/null

    # sddm-kcm
}

launcher() {
    echo "--> Install application launcher."
    sudo pacman -S --noconfirm --needed \
        rofi \
        rofi-calc \
        rofi-emoji \
        rofi-pass \
    &> /dev/null
}

packages() {
    echo "--> Install desktop packages."
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
    echo "--> Install yay."
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
    echo "--> Install yay packages."
    yay -Sy --noconfirm --needed \
        sublime-text \
    &> /dev/null
}

docker() {
    echo "--> Install docker."
    if ! type "docker" > /dev/null; then
        sudo pacman -S docker --noconfirm --needed
        sudo systemctl start docker.service
        sudo systemctl enable docker.service
        sudo newgrp docker
        sudo usermod -aG docker $USER
    fi
}

configure_theme() {
    echo "--> Configure desktop manager theme."
    sudo mkdir -p /etc/sddm.conf.d/
    sudo mkdir -p /usr/share/sddm/themes/luna/

    cat << EOF | sudo tee -a /etc/sddm.conf.d/settings.conf &> /dev/null
[Autologin]
Relogin=false
Session=i3
User=

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Users]
MaximumUid=60000
MinimumUid=1000

[Theme]
Current=luna
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/login.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <defs>
  <style id="current-color-scheme" type="text/css">
   .ColorScheme-Text { color:#dfdfdf; } .ColorScheme-Highlight { color:#4285f4; } .ColorScheme-NeutralText { color:#ff9800; } .ColorScheme-PositiveText { color:#4caf50; } .ColorScheme-NegativeText { color:#f44336; }
  </style>
 </defs>
 <path style="fill:currentColor" class="ColorScheme-Text" d="M 2,9 H 10 L 6.5,12.5 8,14 14,8 8,2 6.5,3.5 10,7 H 2 Z"/>
</svg>
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/power.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <path style="fill:#dfdfdf" d="M 8,1 C 8.554,1 9,1.446 9,2 V 7 C 9,7.554 8.554,8 8,8 7.446,8 7,7.554 7,7 V 2 C 7,1.446 7.446,1 8,1 Z"/>
 <path style="fill:#dfdfdf" d="M 11,3 C 10.448,3 10,3.4477 10,4 10,4.2839 10.102,4.5767 10.329,4.748 11.358,5.525 11.998,6.7108 12,8 12,10.209 10.209,12 8,12 5.7909,12 4,10.209 4,8 4.0024,6.7105 4.644,5.5253 5.6719,4.7471 5.8981,4.5759 5.9994,4.2833 6,4 6,3.4477 5.5523,3 5,3 4.7151,3 4.4724,3.1511 4.2539,3.334 2.8611,4.4998 2.0063,6.1837 2,8 2,11.314 4.6863,14 8,14 11.314,14 14,11.314 14,8 13.996,6.1678 13.137,4.4602 11.714,3.2998 11.504,3.1282 11.267,3 11,3 Z"/>
</svg>
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/reboot.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <path style="fill:#dfdfdf" d="M 8,2 A 1,1 0 0 0 7,3 1,1 0 0 0 8,4 4,4 0 0 1 12,8 H 10 L 13,12 16,8 H 14 A 6,6 0 0 0 8,2 Z M 3,4 0,8 H 2 A 6,6 0 0 0 8,14 1,1 0 0 0 9,13 1,1 0 0 0 8,12 4,4 0 0 1 4,8 H 6 Z"/>
</svg>
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/settings.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <path style="fill:#dfdfdf" d="M 6.25,1 6.09,2.84 A 5.5,5.5 0 0 0 4.49,3.77 L 2.81,2.98 1.06,6.01 2.58,7.07 A 5.5,5.5 0 0 0 2.5,8 5.5,5.5 0 0 0 2.58,8.93 L 1.06,9.98 2.81,13.01 4.48,12.22 A 5.5,5.5 0 0 0 6.09,13.15 L 6.25,15 H 9.75 L 9.9,13.15 A 5.5,5.5 0 0 0 11.51,12.22 L 13.19,13.01 14.94,9.98 13.41,8.92 A 5.5,5.5 0 0 0 13.5,8 5.5,5.5 0 0 0 13.42,7.06 L 14.94,6.01 13.19,2.98 11.51,3.77 A 5.5,5.5 0 0 0 9.9,2.84 L 9.75,1 Z M 8,6 A 2,2 0 0 1 10,8 2,2 0 0 1 8,10 2,2 0 0 1 6,8 2,2 0 0 1 8,6 Z"/>
</svg>
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/sleep.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1" viewBox="0 0 16 16">
 <path style="fill:#dfdfdf" d="M 8,2 A 6,6 0 0 0 2,8 6,6 0 0 0 8,14 6,6 0 0 0 14,8 6,6 0 0 0 8,2 Z M 8,4 A 4,4 0 0 1 12,8 4,4 0 0 1 8,12 4,4 0 0 1 4,8 4,4 0 0 1 8,4 Z"/>
 <path style="fill:#dfdfdf" d="M 10,8 A 2,2 0 0 1 8,10 2,2 0 0 1 6,8 2,2 0 0 1 8,6 2,2 0 0 1 10,8 Z"/>
</svg>
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/metadata.desktop &> /dev/null
[SddmGreeterTheme]
Author      = Nicola Strappazzon
ConfigFile  = theme.conf
Copyright   = (c) 2024, Nicola Strappazzon
Description = Luna theme for SDDM
License     = MIT
MainScript  = Main.qml
Name        = Luna
QtVersion   = 6
# Screenshot  = preview.png
Theme-API   = 2.0
Theme-Id    = nsc
Type        = sddm-theme
Version     = 20240810
Website     = https://gitlab.com/nstrappazzonc/arch
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/theme.conf &> /dev/null
[General]
ClockEnabled            = "false"
ClockPosition           = "center"
CustomBackground        = "false"
Font                    = "Noto Sans"
FontSize                = 12
LoginBackground         = "false"
bgDark                  = "#141416"
bgDefault               = "#1e1e20"
buttonBgFocused0        = "#7a7a7c"
buttonBgFocused1        = "#7a7a7c"
buttonBgHovered0        = "#7a7a7c"
buttonBgHovered1        = "#646466"
buttonBgNormal          = "#1e1e20"
buttonBgPressed         = "#7a7a7c"
buttonBorderFocused     = "#7a7a7c"
buttonBorderHovered     = "#727274"
buttonBorderNormal      = "#5a5a5c"
buttonBorderPressed     = "#7a7a7c"
lineeditBgNormal        = "#1e1e20"
lineeditBorderFocused   = "#7f7f81"
lineeditBorderHovered   = "#7f7f81"
lineeditBorderNormal    = "#5a5a5c"
opacityDefault          = "0.90"
opacityPanel            = "0.95"
textDefault             = "#aaaaac"
textHighlight           = "#dadadc"
textPlaceholder         = "#7f8c8d"
viewitemBgHovered       = "#3a3a3e"
viewitemBgPressed       = "#5c5c5e"
viewitemBorderHovered   = "#6e6e70"
viewitemBorderPressed   = "#6e6e70"
EOF

    cat << EOF | sudo tee -a /usr/share/sddm/themes/luna/Main.qml &> /dev/null
import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    width: 1920
    height: 1080

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#141416"
        anchors.fill: parent
    }

    Rectangle {
        width: 256
        height: 144
        color: config.bgDark
        anchors.centerIn: parent
        opacity: config.opacityPanel

        Column {
            spacing: 8
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            TextField {
                id: usernameInput
                echoMode: TextInput.Normal
                placeholderText: "username"
                placeholderTextColor: config.textPlaceholder
                renderType: Text.NativeRendering
                horizontalAlignment: Text.AlignHLeft
                width: 200
                height: 30
                font {
                    family: config.Font
                    pixelSize: config.FontSize
                    bold: false
                }

                background: Rectangle {
                    id: usernameInputBackground
                    color: config.lineeditBgNormal
                    border.color: config.lineeditBorderNormal
                    border.width: 1
                    radius: 2
                    opacity: config.opacityDefault
                }

                palette {
                    highlight: "#dadadc"
                    highlightedText: "#7f7f81"
                }

                states: [
                    State {
                        name: "hovered"
                        when: usernameInput.hovered
                        PropertyChanges {
                            target: usernameInputBackground
                            border.color: config.lineeditBorderHovered
                        }
                    },
                    State {
                        name: "focused"
                        when: usernameInput.activeFocus
                        PropertyChanges {
                            target: usernameInputBackground
                            border.color: config.lineeditBorderFocused
                        }
                    }
                ]
            }

            Row {
                spacing: 8

                TextField {
                    id: passwordInput
                    echoMode: TextInput.Password
                    placeholderText: "password"
                    placeholderTextColor: config.textPlaceholder
                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignHLeft
                    width: 162
                    height: 30
                    font {
                        family: config.Font
                        pixelSize: config.FontSize
                        bold: false
                    }
                    
                    background: Rectangle {
                        id: passwordInputBackground
                        color: config.lineeditBgNormal
                        border.color: config.lineeditBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    palette {
                        highlight: "#dadadc"
                        highlightedText: "#7f7f81"
                    }

                    states: [
                        State {
                            name: "hovered"
                            when: passwordInput.hovered
                            PropertyChanges {
                                target: passwordInputBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: passwordInput.activeFocus
                            PropertyChanges {
                                target: passwordInputBackground
                                border.color: config.lineeditBorderFocused
                            }
                        }
                    ]
                }

                Button {
                    id: loginButton
                    width: 30
                    height: 30
                    enabled: usernameInput != "" && passwordInput != "" ? true : false
                    hoverEnabled: true
                    icon {
                        source: "login.svg"
                        color: config.textDefault
                    }

                    background: Rectangle {
                        id: loginButtonBackground
                        gradient: Gradient {
                            GradientStop { id: loginButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: loginButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: loginButton.down
                            PropertyChanges {
                                target: loginButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: loginButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: loginButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: loginButton.hovered
                            PropertyChanges {
                                target: loginButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: loginButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: loginButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: loginButton.activeFocus
                            PropertyChanges {
                                target: loginButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: loginButton.enabled
                            PropertyChanges {
                                target: loginButtonBackground
                            }
                            PropertyChanges {
                                target: loginButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.login(usernameInput.text, passwordInput.text, "i3")
                    }
                }
            }

            Row {
                spacing: 8
                width: parent.width
                height: 30
            }

            Row {
                spacing: 8
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: powerButton
                    width: 30
                    height: 30
                    hoverEnabled: true
                    icon {
                        source: Qt.resolvedUrl("power.svg")
                        color: config.textDefault
                    }

                    background: Rectangle {
                        id: powerButtonBackground
                        gradient: Gradient {
                            GradientStop { id: powerButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: powerButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: powerButton.down
                            PropertyChanges {
                                target: powerButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: powerButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: powerButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: powerButton.hovered
                            PropertyChanges {
                                target: powerButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: powerButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: powerButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: powerButton.activeFocus
                            PropertyChanges {
                                target: powerButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: powerButton.enabled
                            PropertyChanges {
                                target: powerButtonBackground
                            }
                            PropertyChanges {
                                target: powerButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.powerOff()
                    }
                }

                Button {
                    id: rebootButton
                    width: 30
                    height: 30
                    hoverEnabled: true
                    icon {
                        source: Qt.resolvedUrl("reboot.svg")
                        color: config.textDefault
                    }

                   background: Rectangle {
                        id: rebootButtonBackground
                        gradient: Gradient {
                            GradientStop { id: rebootButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: rebootButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: rebootButton.down
                            PropertyChanges {
                                target: rebootButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: rebootButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: rebootButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: rebootButton.hovered
                            PropertyChanges {
                                target: rebootButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: rebootButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: rebootButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: rebootButton.activeFocus
                            PropertyChanges {
                                target: rebootButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: rebootButton.enabled
                            PropertyChanges {
                                target: rebootButtonBackground
                            }
                            PropertyChanges {
                                target: rebootButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.reboot()
                    }
                }

                Button {
                    id: sleepButton
                    width: 30
                    height: 30
                    hoverEnabled: true
                    icon {
                        source: Qt.resolvedUrl("sleep.svg")
                        color: config.textDefault
                    }

                   background: Rectangle {
                        id: sleepButtonBackground
                        gradient: Gradient {
                            GradientStop { id: sleepButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: sleepButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: sleepButton.down
                            PropertyChanges {
                                target: sleepButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: sleepButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: sleepButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: sleepButton.hovered
                            PropertyChanges {
                                target: sleepButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: sleepButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: sleepButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: sleepButton.activeFocus
                            PropertyChanges {
                                target: sleepButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: sleepButton.enabled
                            PropertyChanges {
                                target: sleepButtonBackground
                            }
                            PropertyChanges {
                                target: sleepButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.suspend()
                    }
                }
            }
        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            passwordInput.text = ""
            passwordInput.focus = true
        }
    }
}
EOF
}

configure_i3wm() {
    echo "--> Configure desktop."

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
    echo "--> Install terminal."

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
    echo "--> Install bar."

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
    echo "--> Configure application launcher."

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
    echo "--> Configure desktop wallpaper."

    mkdir -p /home/ns/.config/feh/
    cp wallpaper/wallpaper.jpg /home/ns/.config/feh/wallpaper.jpg
}

main "$@"
