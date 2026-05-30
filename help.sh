#!/usr/bin/env bash
set -euo pipefail

ROFI=(rofi -dmenu -i)

show_tips() {
    local title="$1"; shift
    local -a pairs=("$@") labels=()
    local p
    for p in "${pairs[@]}"; do labels+=("${p%%|*}"); done

    local choice
    choice=$(printf '%s\n' "${labels[@]}" | "${ROFI[@]}" -p "$title") || return 0
    [ -z "$choice" ] && return 0

    for p in "${pairs[@]}"; do
      if [ "${p%%|*}" = "$choice" ]; then
        local cmd="${p#*|}"
        printf '%s' "$cmd" | wl-copy
        notify-send "Copied to clipboard" "$cmd"
        return 0
      fi
    done
}

wifi() {
    show_tips "WiFi (nmcli)" \
      "List available networks|nmcli device wifi list" \
      "Rescan networks|nmcli device wifi rescan" \
      "Connect to a new network|nmcli device wifi connect \"SSID\" password \"PASSWORD\"" \
      "Connect to a saved network|nmcli connection up \"SSID\"" \
      "Show active connection|nmcli connection show --active" \
      "List saved connections|nmcli connection show" \
      "Disconnect WiFi|nmcli device disconnect wlan0" \
      "Forget a network|nmcli connection delete \"SSID\"" \
      "Turn WiFi on|nmcli radio wifi on" \
      "Turn WiFi off|nmcli radio wifi off" \
      "WiFi radio status|nmcli radio wifi"
}

shortcuts() {
    show_tips "Sway shortcuts (Super = Logo key)" \
      "Super+Return             →  Open terminal (foot)|Super+Return" \
      "Super+D                  →  App launcher (rofi)|Super+D" \
      "Super+Shift+Q            →  Close window|Super+Shift+Q" \
      "Super+Shift+C            →  Reload Sway|Super+Shift+C" \
      "Super+Shift+E            →  Exit Sway|Super+Shift+E" \
      "Super+H / J / K / L      →  Move focus (← ↓ ↑ →)|Super+H J K L" \
      "Super+Shift+H/J/K/L      →  Move window|Super+Shift+H J K L" \
      "Super+[1-0]              →  Go to workspace N|Super+1..0" \
      "Super+Shift+[1-0]        →  Move window to workspace N|Super+Shift+1..0" \
      "Super+B / Super+V        →  Split horizontal / vertical|Super+B / Super+V" \
      "Super+S                  →  Stacking layout|Super+S" \
      "Super+W                  →  Tabbed layout|Super+W" \
      "Super+E                  →  Toggle split|Super+E" \
      "Super+F                  →  Fullscreen|Super+F" \
      "Super+Shift+Space        →  Toggle floating|Super+Shift+Space" \
      "Super+Space              →  Focus tiling / floating|Super+Space" \
      "Super+A                  →  Focus parent container|Super+A" \
      "Super+Shift+-            →  Send to scratchpad|Super+Shift+minus" \
      "Super+-                  →  Show scratchpad|Super+minus" \
      "Super+R                  →  Resize mode (then H/J/K/L)|Super+R" \
      "Super+Shift+P  /  Print  →  Take screenshot|grim" \
      "Super+Shift+O            →  Select region|slurp" \
      "Screen brightness +/-    →  Brightness keys|XF86MonBrightness" \
      "Keyboard brightness +/-  →  Fn keys|XF86KbdBrightness" \
      "Volume +/- / Mute        →  Media keys|XF86Audio" \
      "Play / Next / Prev       →  Media (playerctl)|XF86Audio"
}

main() {
    local cat
    cat=$(printf '%s\n' "󰌌  Shortcuts" "󰖩  WiFi" | "${ROFI[@]}" -p "Help") || exit 0
    case "$cat" in
      *Shortcuts*)  shortcuts ;;
      *WiFi*)       wifi ;;
    esac
}

main
