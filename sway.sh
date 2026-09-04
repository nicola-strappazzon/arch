#!/usr/bin/env bash

function main() {
  install_packages
  install_fonts
  configure_sway
  configure_gtk
  configure_qt
  configure_quickshell
  configure_waybar
  configure_terminal
  configure_applications
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
    foot                   `# terminal emulator` \
    brightnessctl          `# brightness control` \
    chromium               `# web browser` \
    grim                   `# screenshot tool` \
    lxqt-policykit         `# authentication agent` \
    mako                   `# notification daemon` \
    mpv                    `# media player` \
    slurp                  `# screen region selector` \
    sway                   `# Wayland compositor` \
    swaybg                 `# wallpaper utility` \
    swayidle               `# idle manager` \
    swayimg                `# image viewer` \
    swaylock               `# screen locker` \
    touchegg               `# touchpad gestures` \
    waybar                 `# status bar` \
    quickshell             `# Wayland desktop shell` \
    wl-clipboard           `# clipboard tools` \
    xdg-desktop-portal-wlr `# Wayland desktop portal` \
    xdg-utils              `# desktop utilities` \
    xdg-user-dirs          `# user directory setup` \
    zathura                `# document viewer` \
    zathura-pdf-mupdf      `# Zathura PDF support` \
    nautilus               `# file manager` \
    nautilus-python        `# Nautilus Python extensions` \
    breeze                 `# dark theme for KDE/Qt applications` \
    imv                    `# image viewer` \
    evince                 `# document viewer` \
    mpv-mpris              `# MPV media integration` \
    impala                 `# Wi-Fi interface` \
    unicode-emoji          `# Unicode emoji catalogue` \
    jq                     `# parse Sway state for Quickshell` \
    libnotify              `# notification tools` \
  &> /dev/null
}

function install_fonts() {
  echo "==> Install fonts."
  sudo pacman -S --noconfirm --needed \
    adobe-source-code-pro-fonts \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra \
    ttf-dejavu \
    ttf-fira-code \
    ttf-hack \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-liberation \
    ttf-roboto \
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
set $menu qs ipc call launcher toggle

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

    # Show keyboard shortcuts and command help
    bindsym F1 exec qs ipc call help toggle

    # Search and copy an emoji to the clipboard
    bindsym $mod+period exec qs ipc call emojis toggle

    # Drag floating windows by holding down $mod and left mouse button.
    # Resize them with right mouse button + $mod.
    # Despite the name, also works for non-floating windows.
    # Change normal to inverse to use left mouse button for resizing and right
    # mouse button for dragging.
    floating_modifier $mod normal

    # Reload the configuration file
    bindsym $mod+Shift+c reload

    # Exit sway (logs you out of your Wayland session)
    bindsym $mod+Shift+e exec qs ipc call power toggle

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
bindsym XF86AudioMicMute exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

# multimedia
bindsym XF86AudioPlay exec playerctl play-pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous

# launcher
bindsym XF86LaunchA exec qs ipc call launcher toggle # F3
bindsym XF86LaunchB exec qs ipc call launcher toggle # F4

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
exec_always ~/.config/sway/scripts/quickshell.sh

# notification
exec_always ~/.config/sway/scripts/mako.sh

# mute microphone on session startup
exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1

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

function configure_gtk() {
  echo "==> Configure GTK dark mode."

  if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  else
    dbus-run-session -- gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    dbus-run-session -- gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
  fi
}

function configure_qt() {
  echo "==> Configure KDE/Qt dark mode."

  mkdir -p "$HOME"/.config
  cat > "$HOME"/.config/kdeglobals << 'EOF'
[General]
ColorScheme=BreezeDark
widgetStyle=Breeze

[Icons]
Theme=breeze-dark
EOF
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

function configure_applications() {
  echo "==> Configure application entries."

  local source_dir="/usr/share/applications"
  local target_dir="$HOME/.local/share/applications"
  local application
  local applications=(
    avahi-discover.desktop
    bssh.desktop
    bvnc.desktop
    com.google.Chrome.desktop
    firefox.desktop
    footclient.desktop
    foot-server.desktop
    google-chrome.desktop
    imv-dir.desktop
    links.desktop
    lstopo.desktop
    mimeinfo.cache
    org.gnome.Evince.desktop
    org.gnome.Evince-previewer.desktop
    nautilus-autorun-software.desktop
    org.gnupg.pinentry-qt.desktop
    org.pulseaudio.pavucontrol.desktop
    org.pwmt.zathura.desktop
    org.pwmt.zathura-pdf-mupdf.desktop
    qv4l2.desktop
    qvidcap.desktop
    swayimg.desktop
    user-dirs-update-gtk.desktop
    xdg-desktop-portal-gtk.desktop
    xgps.desktop
    xgpsspeed.desktop
  )

  mkdir -p "$target_dir"

  for application in "${applications[@]}"; do
    if [ -f "$source_dir/$application" ]; then
      cp "$source_dir/$application" "$target_dir/$application"
    else
      echo "Could not find application entry: $source_dir/$application"
    fi
  done
}

function configure_background() {
  echo "==> Configure background."

  mkdir -p "${HOME}/Pictures/"
  wget --quiet --output-document="${HOME}/Pictures/wallpaper.jpg" "https://raw.githubusercontent.com/nicola-strappazzon/arch/refs/heads/main/wallpaper/apple-grass-blades.jpg"
}

function configure_quickshell() {
  echo "==> Configure Quickshell."

  mkdir -p "$HOME"/.config/quickshell

  cat > "$HOME"/.config/quickshell/shell.qml << 'EOF'
import QtQuick
import Quickshell

ShellRoot {
  Loader { source: "bar.qml" }
  Loader { source: "launcher.qml" }
  Loader { source: "emoji-picker.qml" }
  Loader { source: "power-menu.qml" }
  Loader { source: "help-overlay.qml" }
}
EOF

  cat > "$HOME"/.config/quickshell/bar.qml << 'EOF'
import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root
  property int focusedWorkspace: 1
  property string networkStatus: ""
  property string volumeStatus: ""
  property string batteryStatus: ""

  Process {
    id: workspaceProbe
    command: ["bash", "-c", "swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused).num'"]
    stdout: SplitParser {
      onRead: function(line) {
        var value = parseInt(String(line).trim())
        if (!isNaN(value)) root.focusedWorkspace = value
      }
    }
  }

  Process {
    id: networkProbe
    command: ["bash", "-c", "ssid=$(nmcli -t -f ACTIVE,SSID device wifi 2>/dev/null | sed -n 's/^yes://p' | head -n1); printf '%s\\n' \"${ssid:-Offline}\""]
    stdout: SplitParser { onRead: function(line) { root.networkStatus = String(line).trim() } }
  }

  Process {
    id: volumeProbe
    command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{ printf \"%d%%\", $2 * 100 }'"]
    stdout: SplitParser { onRead: function(line) { root.volumeStatus = String(line).trim() } }
  }

  Process {
    id: batteryProbe
    command: ["bash", "-c", "for battery in /sys/class/power_supply/BAT*; do [ -r \"$battery/capacity\" ] && { printf '%s%%\\n' \"$(cat \"$battery/capacity\")\"; break; }; done"]
    stdout: SplitParser { onRead: function(line) { root.batteryStatus = String(line).trim() } }
  }

  Timer {
    interval: 500
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!workspaceProbe.running) workspaceProbe.running = true
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if (!networkProbe.running) networkProbe.running = true
      if (!volumeProbe.running) volumeProbe.running = true
      if (!batteryProbe.running) batteryProbe.running = true
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
      required property var modelData
      screen: modelData
      anchors { top: true; left: true; right: true }
      implicitHeight: 34
      color: "#1b262c"

      Row {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Text {
          text: "󰣇"
          color: "#89b4fa"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 17
          leftPadding: 4
          rightPadding: 8

          MouseArea {
            anchors.fill: parent
            onClicked: Quickshell.execDetached(["qs", "ipc", "call", "launcher", "toggle"])
          }
        }

        Repeater {
          model: 10
          delegate: Text {
            required property int index
            readonly property int workspaceNumber: index + 1
            text: "●"
            color: root.focusedWorkspace === workspaceNumber ? "#89b4fa" : "#6c7086"
            font.pixelSize: 12
            leftPadding: 5
            rightPadding: 5
            transform: Translate { y: 4 }

            MouseArea {
              anchors.fill: parent
              onClicked: {
                root.focusedWorkspace = parent.workspaceNumber
                Quickshell.execDetached(["swaymsg", "workspace", "number", String(parent.workspaceNumber)])
              }
            }
          }
        }
      }

      Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "HH:mm")
        color: "#bbe1fa"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
      }

      Row {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 16

        Text {
          visible: root.networkStatus.length > 0
          text: "  " + root.networkStatus
          color: "#bbe1fa"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 12
          transform: Translate { y: 4 }
        }

        Text {
          visible: root.volumeStatus.length > 0
          text: "  " + root.volumeStatus
          color: "#bbe1fa"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 12
          transform: Translate { y: 4 }
        }

        Text {
          visible: root.batteryStatus.length > 0
          text: "󰁹 " + root.batteryStatus
          color: "#bbe1fa"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 12
          transform: Translate { y: 4 }
        }

        Text {
          text: "󰌌"
          color: "#bbe1fa"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 16
          MouseArea {
            anchors.fill: parent
            onClicked: Quickshell.execDetached(["qs", "ipc", "call", "help", "toggle"])
          }
        }

        Text {
          text: "⏻"
          color: "#f38ba8"
          font.pixelSize: 17
          MouseArea {
            anchors.fill: parent
            onClicked: Quickshell.execDetached(["qs", "ipc", "call", "power", "toggle"])
          }
        }
      }
    }
  }
}
EOF

  cat > "$HOME"/.config/quickshell/launcher.qml << 'EOF'
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root
  property bool opened: false
  property var entries: []

  visible: opened
  anchors { top: true; bottom: true; left: true; right: true }
  color: "#99000000"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  function rebuild() {
    var query = search.text.toLowerCase()
    var values = DesktopEntries.applications.values || []
    var matches = []
    for (var i = 0; i < values.length; ++i) {
      var entry = values[i]
      var name = String(entry.name || entry.id || "")
      if (!query || name.toLowerCase().indexOf(query) >= 0)
        matches.push({ "name": name, "id": String(entry.id || "") })
    }
    matches.sort(function(a, b) { return a.name.localeCompare(b.name) })
    entries = matches.slice(0, 100)
    apps.currentIndex = entries.length ? 0 : -1
  }

  function openOverlay() {
    opened = true
    search.text = ""
    rebuild()
    Qt.callLater(function() { search.forceActiveFocus() })
  }

  function hide() { opened = false }
  function toggle() { opened ? hide() : openOverlay() }

  function launch(index) {
    if (index < 0 || index >= entries.length) return
    var id = entries[index].id
    hide()
    Quickshell.execDetached(["gtk-launch", id + ".desktop"])
  }

  IpcHandler {
    target: "launcher"
    function toggle(): void { root.toggle() }
  }

  MouseArea { anchors.fill: parent; onClicked: root.hide() }

  Rectangle {
    width: Math.min(560, root.width - 40)
    height: Math.min(600, root.height - 80)
    anchors.centerIn: parent
    color: "#1b262c"
    border.color: "#89b4fa"
    border.width: 2
    radius: 8

    MouseArea { anchors.fill: parent; onClicked: function(mouse) { mouse.accepted = true } }

    Column {
      anchors.fill: parent
      anchors.margins: 14
      spacing: 10

      TextInput {
        id: search
        width: parent.width
        height: 38
        color: "#bbe1fa"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
        leftPadding: 10
        verticalAlignment: TextInput.AlignVCenter
        onTextChanged: root.rebuild()
        Keys.onEscapePressed: root.hide()
        Keys.onDownPressed: apps.currentIndex = Math.min(apps.count - 1, apps.currentIndex + 1)
        Keys.onUpPressed: apps.currentIndex = Math.max(0, apps.currentIndex - 1)
        Keys.onReturnPressed: root.launch(apps.currentIndex)

        Rectangle { anchors.fill: parent; z: -1; color: "#073642"; radius: 6 }
      }

      ListView {
        id: apps
        width: parent.width
        height: parent.height - search.height - parent.spacing
        model: root.entries
        clip: true
        spacing: 3

        delegate: Rectangle {
          required property int index
          required property var modelData
          width: apps.width
          height: 38
          radius: 4
          color: ListView.isCurrentItem ? "#073642" : "transparent"

          Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.name
            color: "#bbe1fa"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: apps.currentIndex = index
            onClicked: root.launch(index)
          }
        }
      }
    }
  }
}
EOF

  cat > "$HOME"/.config/quickshell/emoji-picker.qml << 'EOF'
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root
  property bool opened: false
  property var allEmojis: []
  property var matches: []

  visible: opened
  anchors { top: true; bottom: true; left: true; right: true }
  color: "#99000000"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  Process {
    running: true
    command: ["awk", "-F# ", "/; fully-qualified/ { value=$2; sub(/ E[0-9.]+ /, \"\\t\", value); print value }", "/usr/share/unicode/emoji/emoji-test.txt"]
    stdout: SplitParser {
      onRead: function(line) {
        var parts = String(line).trim().split("\t")
        if (parts.length < 2) return
        var next = root.allEmojis.slice()
        next.push({ "emoji": parts[0], "name": parts.slice(1).join(" ") })
        root.allEmojis = next
      }
    }
  }

  function rebuild() {
    var query = search.text.trim().toLowerCase()
    var result = []
    for (var i = 0; i < allEmojis.length && result.length < 300; ++i) {
      var item = allEmojis[i]
      if (!query || item.name.toLowerCase().indexOf(query) >= 0) result.push(item)
    }
    matches = result
    grid.currentIndex = matches.length ? 0 : -1
  }

  onAllEmojisChanged: if (opened) rebuild()

  function openOverlay() {
    opened = true
    search.text = ""
    rebuild()
    Qt.callLater(function() { search.forceActiveFocus() })
  }

  function hide() { opened = false }
  function toggle() { opened ? hide() : openOverlay() }

  function copy(index) {
    if (index < 0 || index >= matches.length) return
    Quickshell.execDetached(["wl-copy", matches[index].emoji])
    hide()
  }

  IpcHandler {
    target: "emojis"
    function toggle(): void { root.toggle() }
  }

  MouseArea { anchors.fill: parent; onClicked: root.hide() }

  Rectangle {
    width: Math.min(560, root.width - 40)
    height: Math.min(560, root.height - 80)
    anchors.centerIn: parent
    color: "#1b262c"
    border.color: "#89b4fa"
    border.width: 2
    radius: 8

    MouseArea { anchors.fill: parent; onClicked: function(mouse) { mouse.accepted = true } }

    Column {
      anchors.fill: parent
      anchors.margins: 14
      spacing: 10

      TextInput {
        id: search
        width: parent.width
        height: 38
        color: "#bbe1fa"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
        leftPadding: 10
        verticalAlignment: TextInput.AlignVCenter
        onTextChanged: root.rebuild()
        Keys.onEscapePressed: root.hide()
        Keys.onLeftPressed: grid.currentIndex = Math.max(0, grid.currentIndex - 1)
        Keys.onRightPressed: grid.currentIndex = Math.min(grid.count - 1, grid.currentIndex + 1)
        Keys.onUpPressed: grid.currentIndex = Math.max(0, grid.currentIndex - Math.max(1, Math.floor(grid.width / grid.cellWidth)))
        Keys.onDownPressed: grid.currentIndex = Math.min(grid.count - 1, grid.currentIndex + Math.max(1, Math.floor(grid.width / grid.cellWidth)))
        Keys.onReturnPressed: root.copy(grid.currentIndex)
        Rectangle { anchors.fill: parent; z: -1; color: "#073642"; radius: 6 }
      }

      GridView {
        id: grid
        width: parent.width
        height: parent.height - search.height - parent.spacing
        model: root.matches
        clip: true
        cellWidth: 58
        cellHeight: 58

        delegate: Rectangle {
          required property int index
          required property var modelData
          width: grid.cellWidth
          height: grid.cellHeight
          radius: 5
          color: GridView.isCurrentItem ? "#073642" : "transparent"

          Text {
            anchors.centerIn: parent
            text: modelData.emoji
            font.family: "Noto Color Emoji"
            font.pixelSize: 28
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: grid.currentIndex = index
            onClicked: root.copy(index)
          }
        }
      }
    }
  }
}
EOF

  cat > "$HOME"/.config/quickshell/help-overlay.qml << 'EOF'
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root
  property bool opened: false
  readonly property var shortcuts: [
    { "key": "Super+Return",          "description": "Open terminal" },
    { "key": "Super+Space",           "description": "Application launcher" },
    { "key": "Super+.",               "description": "Emoji selector" },
    { "key": "Super+Shift+E",         "description": "Session and power menu" },
    { "key": "Super+Shift+Q",         "description": "Close window" },
    { "key": "Super+Shift+C",         "description": "Reload Sway" },
    { "key": "Super+H/J/K/L",         "description": "Move focus" },
    { "key": "Super+Shift+H/J/K/L",   "description": "Move window" },
    { "key": "Super+[1-0]",           "description": "Go to workspace" },
    { "key": "Super+Shift+[1-0]",     "description": "Move window to workspace" },
    { "key": "Super+B / Super+V",     "description": "Split horizontal / vertical" },
    { "key": "Super+F",               "description": "Toggle fullscreen" },
    { "key": "Super+Shift+Space",     "description": "Toggle floating" },
    { "key": "Super+R",               "description": "Resize mode" },
    { "key": "Print",                 "description": "Take screenshot" },
    { "key": "Super+Shift+O",         "description": "Select screen region" }
  ]

  visible: opened
  anchors { top: true; bottom: true; left: true; right: true }
  color: "#99000000"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  function toggle() {
    opened = !opened
    if (opened) Qt.callLater(function() { keys.forceActiveFocus() })
  }

  IpcHandler {
    target: "help"
    function toggle(): void { root.toggle() }
  }

  MouseArea { anchors.fill: parent; onClicked: root.opened = false }

  Rectangle {
    width: Math.min(620, root.width - 40)
    height: Math.min(650, root.height - 80)
    anchors.centerIn: parent
    color: "#1b262c"
    border.color: "#89b4fa"
    border.width: 2
    radius: 8

    MouseArea { anchors.fill: parent; onClicked: function(mouse) { mouse.accepted = true } }

    Item {
      id: keys
      anchors.fill: parent
      focus: true
      Keys.onEscapePressed: root.opened = false
      Keys.onUpPressed: list.currentIndex = Math.max(0, list.currentIndex - 1)
      Keys.onDownPressed: list.currentIndex = Math.min(list.count - 1, list.currentIndex + 1)
    }

    Column {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 12

      Text {
        text: "Keyboard shortcuts"
        color: "#89b4fa"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 18
        font.bold: true
      }

      ListView {
        id: list
        width: parent.width
        height: parent.height - 40
        model: root.shortcuts
        clip: true
        currentIndex: 0

        delegate: Rectangle {
          required property int index
          required property var modelData
          width: list.width
          height: 34
          color: ListView.isCurrentItem ? "#073642" : "transparent"
          radius: 4

          Text {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 230
            text: modelData.key
            color: "#89b4fa"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13
          }

          Text {
            anchors.left: parent.left
            anchors.leftMargin: 250
            anchors.verticalCenter: parent.verticalCenter
            text: modelData.description
            color: "#bbe1fa"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: list.currentIndex = index
          }
        }
      }
    }
  }
}
EOF

  cat > "$HOME"/.config/quickshell/power-menu.qml << 'EOF'
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
  id: root
  property bool opened: false
  readonly property var actions: [
    { "label": "Lock",       "icon": "󰌾", "command": ["swaylock", "-f", "-c", "000000"] },
    { "label": "Suspend",    "icon": "󰤄", "command": ["systemctl", "suspend"] },
    { "label": "Hibernate",  "icon": "󰒲", "command": ["systemctl", "hibernate"] },
    { "label": "Log out",    "icon": "󰍃", "command": ["swaymsg", "exit"] },
    { "label": "Restart",    "icon": "󰜉", "command": ["systemctl", "reboot"] },
    { "label": "Shut down",  "icon": "󰐥", "command": ["systemctl", "poweroff"] }
  ]

  visible: opened
  anchors { top: true; bottom: true; left: true; right: true }
  color: "#99000000"
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  function toggle() {
    opened = !opened
    if (opened) Qt.callLater(function() { keys.forceActiveFocus() })
  }

  function run(index) {
    if (index < 0 || index >= actions.length) return
    var command = actions[index].command
    opened = false
    Quickshell.execDetached(command)
  }

  IpcHandler {
    target: "power"
    function toggle(): void { root.toggle() }
  }

  MouseArea { anchors.fill: parent; onClicked: root.opened = false }

  Rectangle {
    width: Math.min(440, root.width - 40)
    height: 112
    anchors.centerIn: parent
    color: "#1b262c"
    border.color: "#89b4fa"
    border.width: 2
    radius: 8

    MouseArea { anchors.fill: parent; onClicked: function(mouse) { mouse.accepted = true } }

    Item {
      id: keys
      anchors.fill: parent
      focus: true
      Keys.onEscapePressed: root.opened = false
      Keys.onLeftPressed: actionsView.currentIndex = Math.max(0, actionsView.currentIndex - 1)
      Keys.onRightPressed: actionsView.currentIndex = Math.min(actionsView.count - 1, actionsView.currentIndex + 1)
      Keys.onReturnPressed: root.run(actionsView.currentIndex)
    }

    ListView {
      id: actionsView
      anchors.fill: parent
      anchors.margins: 12
      orientation: ListView.Horizontal
      model: root.actions
      spacing: 4
      currentIndex: 0

      delegate: Rectangle {
        required property int index
        required property var modelData
        width: (actionsView.width - actionsView.spacing * 5) / 6
        height: actionsView.height
        radius: 5
        color: ListView.isCurrentItem ? "#073642" : "transparent"

        Column {
          anchors.centerIn: parent
          spacing: 8
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: modelData.icon
            color: modelData.label === "Shut down" ? "#f38ba8" : "#bbe1fa"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 23
          }
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: modelData.label
            color: "#bbe1fa"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 9
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onEntered: actionsView.currentIndex = index
          onClicked: root.run(index)
        }
      }
    }
  }
}
EOF

  cat > "$HOME"/.config/sway/scripts/quickshell.sh << 'EOF'
#!/usr/bin/env bash

pkill -x quickshell 2>/dev/null || true
exec quickshell
EOF

  chmod +x "$HOME"/.config/sway/scripts/quickshell.sh
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
  "modules-right": ["pulseaudio", "pulseaudio#microphone", "network", "battery", "custom/power"],

  "custom/launcher": {
    "format": "󰣇",
    "tooltip": false,
    "on-click": "qs ipc call launcher toggle"
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
    "format": "  {volume}%",
    "format-muted": "  {volume}%",
    "tooltip-format": "Output: {volume}%"
  },

  "pulseaudio#microphone": {
    "format": "{format_source}",
    "format-source": "",
    "format-source-muted": "",
    "tooltip-format": "Input: {source_volume}%",
    "on-click": "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    "target": "source"
  },

  "network": {
    "format-wifi": " ",
    "format-ethernet": "󰈀",
    "format-disconnected": "⚠",
    "tooltip": true,
    "rotate": 0,
    "format-ethernet": " ",
    "tooltip-format": "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}</b>",
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
    "menu": "on-click",
    "menu-file": "~/.config/waybar/power-menu.xml",
    "menu-actions": {
      "lock": "swaylock -f -c 000000",
      "suspend": "systemctl suspend",
      "logout": "swaymsg exit",
      "reboot": "systemctl reboot",
      "shutdown": "systemctl poweroff"
    }
  }
}
EOF

  cat > "$HOME"/.config/waybar/power-menu.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object class="GtkMenu" id="menu">
    <child>
      <object class="GtkMenuItem" id="lock">
        <property name="label">Lock</property>
      </object>
    </child>
    <child>
      <object class="GtkMenuItem" id="suspend">
        <property name="label">Suspend</property>
      </object>
    </child>
    <child>
      <object class="GtkMenuItem" id="logout">
        <property name="label">Logout</property>
      </object>
    </child>
    <child>
      <object class="GtkMenuItem" id="reboot">
        <property name="label">Reboot</property>
      </object>
    </child>
    <child>
      <object class="GtkMenuItem" id="shutdown">
        <property name="label">Shutdown</property>
      </object>
    </child>
  </object>
</interface>
EOF

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

menu {
  color: #bbe1fa;
  background: #1B262C;
  border: 2px solid #89b4fa;
  border-radius: 8px;
  margin-top: 8px;
  padding: 4px;
}

menuitem {
  color: #bbe1fa;
  background: transparent;
  border-radius: 0;
  padding: 6px 12px;
}

menuitem:hover,
menuitem:focus {
  color: #bbe1fa;
  background: #073642;
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
format=<b>%s</b>\n%b
background-color=#1e1e2e
text-color=#cdd6f4
border-color=#d08770
border-size=2
border-radius=8
padding=10
margin=10
default-timeout=5000
anchor=top-right
width=350
height=120

[urgency=low]
border-color=#cccccc

[urgency=normal]
border-color=#d08770

[urgency=critical]
border-color=#bf616a
default-timeout=0
layer=overlay
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
export BROWSER=chromium
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
  cat > "$HOME"/.config/terminal-colors.d/cal.conf << 'EOF'
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

  echo "Installation complete."
}

main
