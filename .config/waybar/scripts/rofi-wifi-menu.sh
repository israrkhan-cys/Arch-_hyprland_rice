#!/bin/bash

# Simple Rofi WiFi Menu using NetworkManager (nmcli)

WIFI_IFACE="wlan0"

# Check if WiFi is enabled
wifi_status() {
    nmcli radio wifi
}

toggle_wifi() {
    if [[ "$(wifi_status)" == "enabled" ]]; then
        nmcli radio wifi off
        notify-send "WiFi" "Disabled"
    else
        nmcli radio wifi on
        notify-send "WiFi" "Enabled"
    fi
}

scan_networks() {
    nmcli device wifi rescan
    nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | awk -F: 'NF>0 {print $1 " (" $2 "%) " $3}' | sort -u
}

connect_wifi() {
    chosen="$1"
    ssid=$(echo "$chosen" | cut -d' ' -f1)

    # Handle empty SSID
    if [[ -z "$ssid" ]]; then
        notify-send "WiFi" "Invalid selection"
        exit 1
    fi

    # If already connected, skip
    nmcli device wifi connect "$ssid" 2>/dev/null && notify-send "WiFi" "Connected to $ssid"
}

main() {
    options="📶 Connect WiFi\n🔄 Rescan\n❌ Disconnect\n⚡ Toggle WiFi\nℹ Status"

    choice=$(echo -e "$options" | rofi -dmenu -i -p "WiFi")

    case "$choice" in
        "📶 Connect WiFi")
            networks=$(scan_networks)
            selected=$(echo "$networks" | rofi -dmenu -i -p "Select Network")
            connect_wifi "$selected"
            ;;
        "🔄 Rescan")
            nmcli device wifi rescan
            notify-send "WiFi" "Rescanned networks"
            ;;
        "❌ Disconnect")
            nmcli connection down id "$(nmcli -t -f NAME connection show --active | head -n 1)"
            notify-send "WiFi" "Disconnected"
            ;;
        "⚡ Toggle WiFi")
            toggle_wifi
            ;;
        "ℹ Status")
            nmcli general status | rofi -dmenu -p "Status (readonly)"
            ;;
    esac
}

main
