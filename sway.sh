#!/usr/bin/env bash

function main() {
  install_packages
  install_yay
  install_fonts
  configure_sway
  configure_waybar
  configure_terminal
  configure_application_launcher
  configure_background
  configure_notification
  configure_helix
  configure_profile
  configure_udev
  configure_calendar
  finish
}

function install_packages() {
  echo "==> Install packages."
  sudo pacman -S --noconfirm --needed \
    foot                   `# terminal` \
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
    wlogout                `# ...` \
    wl-clipboard           `# clipboard` \
    xdg-desktop-portal-wlr `# compatibilidad con apps` \
    xdg-utils              `# ...` \
    xdg-user-dirs          `# create user directories` \
    zathura                `# document viewer` \
    zathura-pdf-mupdf      `# pdf support for zathura` \
    nautilus               `# ...` \
    nautilus-python        `# ...` \
    imv                    `# ...` \
    evince                 `# ...` \
    mpv                    `# ...` \
    mpv-mpris              `# ...` \
    impala                 `# ...` \
    rofi-wayland           `# ...` \
    firefox                `# web browser` \
    libnotify              `# ...` \
  &> /dev/null
}

function install_yay() {
  echo "==> Install yay tool."
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

function install_fonts() {
  echo "==> Install fonts."
  sudo pacman -S --noconfirm --needed \
    ttf-jetbrains-mono-nerd \
  &> /dev/null

  sudo fc-cache --force &> /dev/null
}

function configure_sway() {
  echo "==> Configure sway."

  mkdir -p "$HOME"/.config/sway/
  mkdir -p "$HOME"/.config/sway/scripts

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
set $term foot
# Your preferred application launcher
set $menu rofi -show run -theme-str 'mainbox { children: [ inputbar ]; }'

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
    bindsym $mod+space exec $menu

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
    bindsym $mod+Shift+b splith
    bindsym $mod+Shift+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    # bindsym $mod+space focus mode_toggle

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
bindsym XF86LaunchA exec rofi -show drun # F3
bindsym XF86LaunchB exec rofi -show drun # F4

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

# notification
exec_always ~/.config/sway/scripts/mako.sh

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
  cat > "$HOME"/.config/sway/scripts/mako.sh << 'EOF'
#!/bin/bash

pkill -x mako
mako
EOF

  chmod +x "$HOME"/.config/sway/scripts/mako.sh
}

function configure_terminal() {
  mkdir -p "$HOME"/.config/foot/
  cat > "$HOME"/.config/foot/foot.ini  << 'EOF'
font=JetBrainsMono Nerd Font:size=10
pad=1x1
term=xterm-256color

[scrollback]
lines=10000

[cursor]
style=block
blink=yes

[key-bindings]
primary-paste=Super+v
EOF
}

function configure_application_launcher() {
  echo "==> Configure application launcher."

  mkdir -p "$HOME"/.config/rofi/
  cat > "$HOME"/.config/rofi/config.rasi << 'EOF'
configuration {
    modi:                "drun,run";
    show-icons:          false;
    drun-display-format: "{name}";
    display-drun:        "";
    display-run:         "";
}

* {
    bg:     #1B262C;
    bg-alt: #073642;
    fg:     #839496;
    fg-alt: #93a1a1;
    accent: #89b4fa;
    urgent: #dc322f;

    background-color: transparent;
    text-color:       @fg;
    font:             "JetBrainsMono Nerd Font 10";
}

window {
    background-color: @bg;
    border:           2px;
    border-color:     @accent;
    border-radius:    8px;
    width:            40%;
    padding:          10px;
}

mainbox {
    children: [ inputbar, listview ];
}

inputbar {
    background-color: @bg-alt;
    text-color:       @fg-alt;
    padding:          8px;
    border-radius:    6px;
    spacing:          8px;
    children:         [ prompt, entry ];
}

prompt {
    text-color: @accent;
}

entry {
    placeholder:       "";
    placeholder-color: @fg;
}

listview {
    lines:     10;
    spacing:   4px;
    scrollbar: false;
}

element {
    padding:       6px 8px;
    border-radius: 6px;
}

element selected {
    background-color: @accent;
    text-color:       @bg;
}

element-icon {
    size:    1.1em;
    padding: 0 6px 0 0;
}

element-text {
    text-color:     inherit;
    vertical-align: 0.5;
}
EOF
}

function configure_background() {
  echo "==> Configure background."

  mkdir -p "${HOME}/Pictures/"
  wget --quiet --output-document="${HOME}/Pictures/wallpaper.jpg" "https://raw.githubusercontent.com/nicola-strappazzon/arch/refs/heads/main/wallpaper/apple-grass-blades.jpg"
}

function configure_waybar() {
  echo "==> Configure waybar."

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
    "tooltip": false,
    "on-click": "rofi -show drun"
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
    }
  },

  "custom/power": {
    "format": "⏻",
    "tooltip": false,
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

#workspaces button,
#workspaces button:hover,
#workspaces button:focus,
#workspaces button:active,
#workspaces button.focused,
#workspaces button.focused:hover {
  border: none;
  box-shadow: 0 0 transparent;
  background: transparent;
  font-weight: normal;
}

#workspaces button.focused {
  color: #89b4fa;
}

#workspaces button:not(.focused):hover {
  color: #cdd6f4;
}

#custom-launcher {
  padding: 0 12px;
  color: #89b4fa;
}

#custom-launcher:hover {
  color: #cdd6f4;
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

function configure_notification() {
  echo "==> Configure notification."

  mkdir -p "$HOME"/.config/mako/
  cat > "$HOME"/.config/mako/config << 'EOF'
font=JetBrains Mono 10
background-color=#1e1e2e
text-color=#cdd6f4
border-color=#89b4fa
border-size=2
border-radius=8
padding=10
margin=10
default-timeout=5000
anchor=top-right
width=350
height=120

[urgency=critical]
default-timeout=0
layer=overlay

[urgency=high]
border-color=#f38ba8
default-timeout=0
EOF
}

function configure_helix() {
  echo "--> Configure Helix"

  mkdir -p "$HOME"/.config/helix/
  cat > "$HOME"/.config/helix/config.toml << 'EOF'
theme = "adwaita-dark"

[keys.normal]
y = "yank_joined_to_clipboard"
p = "paste_clipboard_before"
C-up = [ # scroll selections up one line
    "ensure_selections_forward",
    "extend_to_line_bounds",
    "extend_char_right",
    "extend_char_left",
    "delete_selection",
    "move_line_up",
    "add_newline_above",
    "move_line_up",
    "replace_with_yanked"
]
C-down = [ # scroll selections down one line
    "ensure_selections_forward",
    "extend_to_line_bounds",
    "extend_char_right",
    "extend_char_left",
    "delete_selection",
    "add_newline_below",
    "move_line_down",
    "replace_with_yanked"
]

[editor.whitespace.render]
space = "all"
tab = "all"
newline = "none"

EOF
}

function configure_profile() {
  echo "--> Configure profile."

  mkdir -p "$HOME"/.bashrc.d/
  mkdir -p "$HOME"/.bashrc.d/alias/
  mkdir -p "$HOME"/.bashrc.d/env/
  mkdir -p "$HOME"/.bashrc.d/functions/
  chmod -R 0700 "$HOME"/.bashrc.d

  cat > "$HOME"/.bashrc.d/alias.sh << 'EOF'
if [ -x ~/.bashrc.d/alias/ ]; then
  for i in $(find ~/.bashrc.d/alias/ -type f ); do
    source "$i"
  done
fi
EOF

  cat > "$HOME"/.bashrc.d/env.sh << 'EOF'
if [ -x ~/.bashrc.d/env/ ]; then
  for i in $(find ~/.bashrc.d/env/ -type f ); do
    source "$i"
  done
fi
EOF

  cat > "$HOME"/.bashrc.d/functions.sh << 'EOF'
if [ -x ~/.bashrc.d/functions/ ]; then
  for i in $(find ~/.bashrc.d/functions/ -type f ); do
    source "$i"
  done
fi
EOF

  cat > "$HOME"/.bashrc.d/alias/general.sh << 'EOF'
alias c="reset;clear"
alias d="diff --color=auto"
alias x="yazi"
alias f="fzf -i --print0 | xclip -selection clipboard"
alias g="grep --color"
alias h="history"
alias e="helix"
alias ll="lsd -laS --color=auto"
alias l="lsd -lahS --color=auto"
alias md="glow --line-numbers --pager"
alias o="dolphin . &> /dev/null &"
alias r="source ~/.bashrc"
alias t="btop"
alias copy='xclip -sel clip'
alias cal='cal -3'
EOF

  cat > "$HOME"/.bashrc.d/env/general.sh << 'EOF'
export MOZ_ENABLE_WAYLAND=1
export BROWSER=firefox
export CLICOLOR=1
export EDITOR=helix
export SUDO_EDITOR=$(which helix)
export GOPATH=$HOME/go
export LS_COLORS="di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31"
export PATH=$PATH:$(go env GOPATH)/bin
export PS1="\[\033[32m\]\W\[\033[31m\]\[\033[32m\]$\[\e[0m\] "
export TERM=xterm
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:';
EOF
}

function configure_udev() {
  echo "--> Configure udev rules."

  cat << EOF | sudo tee /etc/udev/rules.d/50-embedded_devices.rules &> /dev/null
SUBSYSTEMS=="usb", ATTRS{product}== "Arduino Uno", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "FT232R USB UART", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "USBtiny", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "USBtinyISP", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "QinHeng Electronics CH340 serial converter", GROUP="users", MODE="0666"
EOF

  sudo udevadm control --reload
  sudo udevadm trigger
}

function configure_calendar() {
  echo "==> Configure calendar."

  mkdir -p "$HOME"/.config/terminal-colors.d/
  cat > "$HOME"/.config/rofi/config.rasi << 'EOF'
weekend 35
today 1;41
header yellow
EOF
}

function finish() {
  xdg-user-dirs-update

  if [ -n "$SWAYSOCK" ]; then
    swaymsg reload 2>/dev/null || true
    makoctl reload 2>/dev/null || true
  fi

  sudo -k
}

main
