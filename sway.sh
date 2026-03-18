#!/usr/bin/env bash
# set -eu

function main() {
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
    sway                   `# window manager Wayland` \
    swaybg                 `# fondo de pantalla` \
    swaylock               `# lock screen` \
    swayidle               `# gestión de idle / suspensión` \
    waybar                 `# barra superior` \
    wmenu                  `# launcher o usar wofi` \
    mako                   `# notificaciones` \
    grim                   `# screenshots` \
    slurp                  `# seleccionar región screenshot` \
    wl-clipboard           `# clipboard` \
    xdg-desktop-portal-wlr `# compatibilidad con apps` \
    xdg-open               `# ...` \
    lxqt-policykit         `# authentication agent` \
    luakit                 `# web browser` \
    touchegg               `# gestos para el touch mouse` \
    brightnessctl          `# gestor de brillo de pantalla` \
  &> /dev/null
}

function install_yay_packages() {
  echo "--> Install yay packages."

  yay -Sy --noconfirm --needed \
    wlogout `# sleep/logout/reboot/shutdown` \
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
  cp /etc/sway/config "$HOME"/.config/sway/config

cat << EOF | sudo tee /etc/sway/config.d/60-user-custom.conf &> /dev/null
set \$term alacritty
set \$menu wmenu-run
EOF

cat << EOF | sudo tee /etc/sway/config.d/60-user-brightness.conf &> /dev/null
bindsym --locked XF86MonBrightnessDown exec brightnessctl set 5%-
bindsym --locked XF86MonBrightnessUp exec brightnessctl set 5%+
EOF

  cat << EOF | sudo tee /etc/sway/config.d/60-user-backlight.conf &> /dev/null
bindsym XF86KbdBrightnessUp exec brightnessctl -d smc::kbd_backlight set +20%
bindsym XF86KbdBrightnessDown exec brightnessctl -d smc::kbd_backlight set 20%-
EOF

  cat << EOF | sudo tee /etc/sway/config.d/60-user-volumen.conf &> /dev/null
bindsym XF86AudioRaiseVolume exec pamixer -i 5
bindsym XF86AudioLowerVolume exec pamixer -d 5
bindsym XF86AudioMute exec pamixer -t
EOF

  cat << EOF | sudo tee /etc/sway/config.d/60-user-multimedia.conf &> /dev/null
bindsym XF86AudioPlay exec playerctl play-pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous
EOF

  cat << EOF | sudo tee /etc/sway/config.d/60-user-launcher.conf &> /dev/null
bindsym XF86LaunchA exec wmenu-run # F3
bindsym XF86LaunchB exec wmenu-run # F4
EOF

  cat << EOF | sudo tee /etc/sway/config.d/60-user-touchpad.conf &> /dev/null
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
}

function configure_background() {
  echo "--> Configure background."
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
  "modules-right": ["cpu", "memory", "disk", "pulseaudio", "network", "battery", "custom/power"],

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
    "tooltip-format": "{capacity}% ({time})"
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
  border-bottom: 2px solid transparent;
  color: rgb(187, 225, 250);
}


#workspaces button {
  padding: 0 6px;
  color: #6c7086;
  font-size: 10px;
  transition: all 0.2s ease;
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
  sudo -k
}

main "$@"
