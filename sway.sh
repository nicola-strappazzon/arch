#!/usr/bin/env bash
# set -eu

function main() {
  update_date
  install_packages
  install_yay
  install_yay_packages
  install_fonts
  configure_sway
  configure_waybar
  configure_background
  configure_alacritty
  finish
}

function update_date() {
  echo "==> Update date."
  sudo timedatectl set-ntp true
  sudo hwclock --systohc
}

function install_yay() {
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

function install_packages() {
  echo "--> Install packages."
  sudo pacman -S --noconfirm --needed \
    alacritty              `# terminal` \
    brightnessctl          `# gestor de brillo de pantalla` \
    grim                   `# screenshots` \
    lxqt-policykit         `# authentication agent` \
    mako                   `# notificaciones` \
    mpv                    `# media player` \
    slurp                  `# seleccionar región screenshot` \
    sway                   `# window manager Wayland` \
    swaybg                 `# fondo de pantalla` \
    swayidle               `# gestión de idle / suspensión` \
    swayimg                `# image viewer` \
    swaylock               `# lock screen` \
    touchegg               `# gestos para el touch mouse` \
    waybar                 `# barra superior` \
    wl-clipboard           `# clipboard` \
    wmenu                  `# launcher o usar wofi` \
    xdg-desktop-portal-wlr `# compatibilidad con apps` \
    xdg-open               `# ...` \
    xdg-user-dirs          `# create user directories` \
    zathura                `# document viewer` \
    zathura-pdf-mupdf      `# pdf support for zathura` \
  &> /dev/null
}

function install_yay_packages() {
  echo "--> Install yay packages."

  yay -Sy --noconfirm --needed \
    wlogout       `# sleep/logout/reboot/shutdown` \
    librewolf-bin `# web browser` \
  &> /dev/null
}

function install_fonts() {
  echo "--> Install fonts."
  sudo pacman -S --noconfirm --needed \
    ttf-jetbrains-mono-nerd \
  &> /dev/null

  sudo fc-cache --force &> /dev/null
}

function configure_sway() {
  echo "--> Configure sway."

  mkdir -p "$HOME"/.config/sway/
  mkdir -p "$HOME"/.config/sway/scripts
  # cp /etc/sway/config "$HOME"/.config/sway/config

cat > "$HOME"/.config/sway/config << 'EOF'
font pango:JetBrains Mono 12

#
# Logo key. Use Mod1 for Alt.
set $mod Mod4
# Home row direction keys, like vim
set $left h
set $down j
set $up k
set $right l
# Your preferred terminal emulator
set $term alacritty
# Your preferred application launcher
set $menu wmenu-run

### Idle configuration
exec swayidle -w \
  timeout 120 'swaylock -f -c 000000' \
  timeout 300 'swaymsg "output * power off"' \
  resume 'swaymsg "output * power on"' \
  before-sleep 'swaylock -f -c 000000'

### Key bindings
#
# Basics:
#
    # Start a terminal
    bindsym $mod+Return exec $term

    # Kill focused window
    bindsym $mod+Shift+q kill

    # Start your launcher
    bindsym $mod+d exec $menu

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Despite the name, also works for non-floating windows.
    # Change normal to inverse to use left mouse button for resizing and right
    # mouse button for dragging.
    floating_modifier $mod normal

    # Reload the configuration file
    bindsym $mod+Shift+c reload

    # Exit sway (logs you out of your Wayland session)
    bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'

    # Screenshot
    bindsym $mod+Shift+p exec grim

    # screenshot region
    bindsym $mod+Shift+o exec slurp
#
# Moving around:
#
    # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
    # Or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

    # Move the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
    # Ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right
#
# Workspaces:
#
    # Switch to workspace
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10
    # Move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10
    # Note: workspaces can have any name you want, not just numbers.
    # We just use 1-10 as the default.
#
# Layout stuff:
#
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # Move focus to the parent container
    bindsym $mod+a focus parent
#
# Scratchpad:
#
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show
#
# Resizing containers:
#
mode "resize" {
    # left will shrink the containers width
    # right will grow the containers width
    # up will shrink the containers height
    # down will grow the containers height
    bindsym $left resize shrink width 10px
    bindsym $down resize grow height 10px
    bindsym $up resize shrink height 10px
    bindsym $right resize grow width 10px

    # Ditto, with arrow keys
    bindsym Left resize shrink width 10px
    bindsym Down resize grow height 10px
    bindsym Up resize shrink height 10px
    bindsym Right resize grow width 10px

    # Return to default mode
    bindsym Return mode "default"
    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

# brightness
bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+

# screenshot
bindsym Print exec grim

# backlight keyboard
bindsym XF86KbdBrightnessUp exec brightnessctl -d smc::kbd_backlight set +20%
bindsym XF86KbdBrightnessDown exec brightnessctl -d smc::kbd_backlight set 20%-

# volumen
bindsym XF86AudioRaiseVolume exec pamixer -i 5
bindsym XF86AudioLowerVolume exec pamixer -d 5
bindsym XF86AudioMute exec pamixer -t

# multimedia
bindsym XF86AudioPlay exec playerctl play-pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous

# launcher
bindsym XF86LaunchA exec wmenu-run # F3
bindsym XF86LaunchB exec wmenu-run # F4

# windows theme
#                       border  background text    indicator child_border
client.focused          #89b4fa #89b4fa    #1e1e2e #89b4fa   #89b4fa
client.unfocused        #313244 #313244    #cdd6f4 #313244   #313244
client.focused_inactive #45475a #45475a    #cdd6f4 #45475a   #45475a
client.urgent           #f38ba8 #f38ba8    #1e1e2e #f38ba8   #f38ba8

# disable title on windows
default_border pixel 2
default_floating_border pixel 2

# windows gap
gaps inner 4
gaps outer 4
smart_gaps on
smart_borders on

# wallpaper
output * bg ~/Pictures/wallpaper.jpg fill

# bar
exec_always ~/.config/sway/scripts/waybar.sh

include /etc/sway/config.d/*
EOF

  cat << EOF | sudo tee /etc/sway/config.d/60-touchpad.conf &> /dev/null
input "type:touchpad" {
  accel_profile adaptive
  click_method clickfinger
  drag enabled
  drag_lock enabled
  dwt enabled
  middle_emulation enabled
  natural_scroll enabled
  pointer_accel 0.3
  tap enabled
}
EOF

  cat > "$HOME"/.config/sway/scripts/waybar.sh << 'EOF'
#!/bin/bash

pkill -x waybar
waybar
EOF

  chmod +x "$HOME"/.config/sway/scripts/waybar.sh
}

function configure_background() {
  echo "--> Configure background."

  wget --quiet --output-document="${HOME}/Pictures/wallpaper.jpg" "https://raw.githubusercontent.com/nicola-strappazzon/arch/refs/heads/main/wallpaper/apple-grass-blades.jpg"
}

function configure_waybar() {
  echo "--> Configure waybar."


  mkdir -p "$HOME"/.config/waybar/
  cat > "$HOME"/.config/waybar/config << 'EOF'
{
  "layer": "top",
  "position": "top",

  "modules-left": ["custom/launcher", "sway/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["pulseaudio", "network", "battery", "custom/power"],

  "custom/launcher": {
    "format": "󰣇",
    "tooltip": "Applications",
    "on-click": "wmenu-run"
  },

  "sway/workspaces": {
    "all-outputs": true,
    "format": "{icon}",
    "on-click": "activate",
  "persistent-workspaces": {
    "1": "●",
    "2": "●",
    "3": "●",
    "4": "●",
    "5": "●",
    "6": "●",
    "7": "●",
    "8": "●",
    "9": "●"
  },
  "format-icons": {
    "1": "●",
    "2": "●",
    "3": "●",
    "4": "●",
    "5": "●",
    "6": "●",
    "7": "●",
    "8": "●",
    "9": "●"
  },
      "sort-by-number": true
  },

  "clock": {
    "format": "{:%H:%M}",
    "rotate": 0,
    "format-alt": "{  %d·%m·%y}",
    "tooltip-format": "<span>{calendar}</span>",
    "calendar": {
      "mode": "month",
      "format": {
        "months": "<span color='#ff6699'><b>{}</b></span>",
        "days": "<span color='#cdd6f4'><b>{}</b></span>",
        "weekdays": "<span color='#7CD37C'><b>{}</b></span>",
        "today": "<span color='#ffcc66'><b>{}</b></span>"
      }
    }
  },

  "cpu": {
    "interval": 1,
    "format": "{icon}",
    "format-icons": ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
  },

  "memory": {
    "interval": 30,
    "format": "",
    "tooltip-format": "{used:0.1f}G/{total:0.1f}G"
  },

  "disk": {
    "interval": 30,
    "format": "/",
    "tooltip-format": "{used}/{total}",
    "unit": "GB"
  },

  "pulseaudio": {
    "format": " ",
    "format-muted": "",
    "tooltip-format": "Volume: {volume}%"
  },

  "network": {
    "format-wifi": " ",
    "format-ethernet": "󰈀",
    "format-disconnected": "⚠",
    "tooltip": true,
    "rotate": 0,
    "format-ethernet": " ",
    "tooltip-format": "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>",
    "format-linked": " {ifname} (No IP)",
    "format-disconnected": "󰖪 ",
    "tooltip-format-disconnected": "Disconnected",
    "format-alt": "<span foreground='#99ffdd'> {bandwidthDownBytes}</span> <span foreground='#ffcc66'> {bandwidthUpBytes}</span>",
    "interval": 2
  },

  "battery": {
    "format": "{icon}",
    "format-icons": {
        "default": ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "charging": ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
    },
    "tooltip-format": "{capacity}% ({time})",
    "states": {
      "warning": 30,
      "critical": 15
    },
  },

  "custom/power": {
    "format": "⏻",
    "on-click": "wlogout"
  }
}
EOF

  mkdir -p "$HOME"/.config/waybar/
  cat > "$HOME"/.config/waybar/style.css << 'EOF'
* {
  font-family: "JetBrainsMono Nerd Font";
  border: none;
  border-radius: 0;
  font-size: 16px;
  min-height: 0;
}

window#waybar {
  background: rgba(27, 38, 44, 1);
  color: rgb(187, 225, 250);
}


#workspaces button {
  padding: 0 6px;
  color: #6c7086;
  font-size: 10px;
}

#workspaces button.focused {
  color: #89b4fa;
  font-weight: bold;
}

#workspaces button:not(.focused):hover {
  color: #cdd6f4;
}


#custom-launcher {
  padding: 0 12px;
  color: #89b4fa;
}

#custom-launcher:hover {
  background: #313244;
  border-radius: 6px;
}

#custom-power {
  color: #D53E0F;
}

#battery {
    color: rgb(187, 225, 250);
}

#battery.warning {
    color: #f9e2af;
}

#battery.critical {
    color: #D53E0F;
}

#cpu,
#memory,
#disk,
#clock,
#battery,
#network,
#pulseaudio,
#custom-power {
    padding: 0 8px;
}
EOF
}

function configure_alacritty() {
  echo "--> Configure Alacritty."

  mkdir -p "$HOME"/.config/alacritty/
  cat > "$HOME"/.config/alacritty/alacritty.toml << 'EOF'
[terminal]
shell = { program = "/bin/bash" }

[bell]
duration = 0

[cursor.style]
blinking = "Always"
shape = "Underline"

[selection]
save_to_clipboard = true

[mouse]
bindings = [{mouse = "Right", action = "Paste"}]

[window]
opacity = 1.0
startup_mode = "Maximized"
EOF
}

function finish() {
  xdg-user-dirs-update

  sudo -k
}

main "$@"
