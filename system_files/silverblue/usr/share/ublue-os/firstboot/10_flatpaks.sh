#!/bin/bash

kde_flatpaks=(
    org.kde.kalk
    org.kde.gwenview
    org.kde.kontact
    org.kde.okular
    org.kde.kweather
    org.kde.kclock
    org.kde.haruna
    org.kde.skanpage
    runtime/org.gtk.Gtk3theme.Breeze
)

gnome_flatpaks=(
    org.gnome.baobab
    org.gnome.Calculator
    org.gnome.Calendar
    org.gnome.Characters
    org.gnome.Papers
    org.gnome.Firmware
    org.gnome.font-viewer
    org.gnome.Logs
    org.gnome.Loupe
    org.gnome.NautilusPreviewer
    org.gnome.seahorse.Application
    org.gnome.Showtime
    org.gnome.TextEditor
    org.gnome.Weather
    com.mattjakeman.ExtensionManager
)

communication_flatpaks=(
    com.discordapp.Discord
    com.slack.Slack
    org.signal.Signal
    org.telegram.desktop
)

gaming_flatpaks=(
    org.polymc.PolyMC
    com.valvesoftware.Steam
)

internet_flatpaks=(
    com.github.micahflee.torbrowser-launcher
)

multimedia_flatpaks=(
    sh.cider.genten
    com.spotify.Client
    org.freedesktop.Platform.ffmpeg-full//22.08
)

productivity_flatpaks=(
    org.libreoffice.LibreOffice
)

utilities_flatpaks=(
    com.usebottles.bottles
    io.github.dvlv.boxbuddyrs
    com.github.tchx84.Flatseal
    org.fedoraproject.MediaWriter
    io.missioncenter.MissionCenter
    md.obsidian.Obsidian
    net.cozic.joplin_desktop
    org.keepassxc.KeePassXC
    com.borgbase.Vorta
)

profile=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Detected: $profile"

if ! rpm -q firefox >/dev/null 2>&1; then
    need_firefox_flatpak=1
fi

if ! rpm -q bitwarden >/dev/null 2>&1; then
    need_bitwarden_flatpak=1
fi

read -p "Do you want to install all system flatpaks? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then

    echo "Disable all repos but flathub for this install .. "
    flatpak remote-delete fedora --force || true
    flatpak remote-delete fedora-testing --force || true

    read -p "Do you want to clean and remove all current system flatpaks? (recommended for first run) (y/n): " clean_choice
    if [[ "$clean_choice" =~ ^[Yy]$ ]]; then
        flatpak remove --system --noninteractive --all
    else
        case "$profile" in
            aurora)
                read -p "Do you want to remove GNOME (bluefin) Flatpaks before proceeding? (y/n): " rm_choice
                if [[ "$rm_choice" =~ ^[Yy]$ ]]; then
                    echo "Removing GNOME (bluefin) Flatpaks..."
                    flatpak remove -y --system "${gnome_flatpaks[@]}"
                fi
                ;;
            bluefin)
                read -p "Do you want to remove KDE (aurora) Flatpaks before proceeding? (y/n): " rm_choice
                if [[ "$rm_choice" =~ ^[Yy]$ ]]; then
                    echo "Removing KDE (aurora) Flatpaks..."
                    flatpak remove -y --system "${kde_flatpaks[@]}"
                fi
                ;;
            *)
                echo "Unknown profile '$profile', skipping removal of other profile apps."
                ;;
        esac
    fi
    
    flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

    case "$profile" in
        aurora)
            echo "Installing KDE (aurora) Flatpaks..."
            flatpak install -y --system "${kde_flatpaks[@]}"
            ;;
        bluefin)
            echo "Installing GNOME (bluefin) Flatpaks..."
            flatpak install -y --system "${gnome_flatpaks[@]}"
            ;;
        *)
            echo "Unknown profile '$profile' - no profile-specific installs performed."
            ;;
    esac

    echo "Communication applications ..."
    flatpak install -y --system "${communication_flatpaks[@]}"

    echo "Gaming applications ..."
    flatpak install -y --system "${gaming_flatpaks[@]}"

    echo "Internet applications ..."
    flatpak install -y --system "${internet_flatpaks[@]}"
    if [[ "$need_firefox_flatpak" == "1" ]]; then
        flatpak install -y --system org.mozilla.firefox
    fi

    echo "Multimedia applications ..."
    flatpak install -y --system "${multimedia_flatpaks[@]}"

    echo "Productivity applications ..."
    flatpak install -y --system "${productivity_flatpaks[@]}"
  
    echo "Utilities ..."
    flatpak install -y --system "${utilities_flatpaks[@]}"
    if [[ "$need_bitwarden_flatpak" == "1" ]]; then
        flatpak install -y --system com.bitwarden.desktop
    fi
fi
