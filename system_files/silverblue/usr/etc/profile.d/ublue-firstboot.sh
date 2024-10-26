#!/bin/bash

get_fedora_major_version() {
    rpm -E %fedora
}

firstboot_dir="$HOME/.config/ublue-os/firstboot"
firstboot_setup_file="$firstboot_dir/firstboot-setup-done"
firstboot_desktop="ublue-firstboot.desktop"
firstboot_profiled="/etc/profile.d/ublue-firstboot.sh"
last_fedora_major_file="$firstboot_dir/last-fedora-major"
autostart_dir="$HOME/.config/autostart"
autostart_skel="/etc/skel.d/.config/autostart"

# check if we are the first user
if [ "$(id -u)" -eq 1000 ] && [ -d "$HOME" ]; then
    
    # check if there was a major version update or firstboot setup file was removed
    [ -f "$last_fedora_major_file" ] && last_fedora_major=$(cat "$last_fedora_major_file")
    current_fedora_major=$(get_fedora_major_version)
    if [ "$last_fedora_major" != "$current_fedora_major" ] || [ ! -f "$firstboot_setup_file" ]; then
        [ ! -d "$autostart_dir" ] && mkdir -p "$autostart_dir"
        cp -f "$autostart_skel/$firstboot_desktop" "$autostart_dir"
        [ ! -d "$firstboot_dir" ] && mkdir -p "$firstboot_dir"
        echo "$current_fedora_major" > "$last_fedora_major_file"
    fi
fi

rm -f $autostart_dir/$firstboot_desktop
rm -f $0