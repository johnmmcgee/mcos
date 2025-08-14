#!/bin/bash

profile=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Detected: $profile"

if ! rpm -q firefox >/dev/null 2>&1; then
    echo "Firefox not installed as RPM — will install Flatpak later..."
    NEED_FIREFOX_FLATPAK=1
else
    echo "Firefox installed as RPM — skipping Flatpak install."
fi

if ! rpm -q bitwarden >/dev/null 2>&1; then
    echo "Bitwarden not installed as RPM — will install Flatpak later..."
    NEED_BITWARDEN_FLATPAK=1
else
    echo "Bitwarden installed as RPM — skipping Flatpak install."
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
                    flatpak remove -y --system \
                        org.gnome.baobab \
                        org.gnome.Calculator \
                        org.gnome.Calendar \
                        org.gnome.Characters \
                        org.gnome.Evince \
                        org.gnome.Firmware \
                        org.gnome.font-viewer \
                        org.gnome.Logs \
                        org.gnome.Loupe \
                        org.gnome.NautilusPreviewer \
                        org.gnome.seahorse.Application \
                        org.gnome.TextEditor \
                        org.gnome.Weather \
                        com.mattjakeman.ExtensionManager
                fi
                ;;
            bluefin)
                read -p "Do you want to remove KDE (aurora) Flatpaks before proceeding? (y/n): " rm_choice
                if [[ "$rm_choice" =~ ^[Yy]$ ]]; then
                    echo "Removing KDE (aurora) Flatpaks..."
                    flatpak remove -y --system \
                        org.kde.kalk \
                        org.kde.gwenview \
                        org.kde.kontact \
                        org.kde.okular \
                        org.kde.kweather \
                        org.kde.kclock \
                        org.kde.haruna \
                        org.kde.skanpage \
                        runtime/org.gtk.Gtk3theme.Breeze
                fi
                ;;
            *)
                echo "Unknown profile '$profile', skipping removal of other profile apps."
                ;;
        esac
    fi
    
    flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Installing flatpaks that we wish to be system-wide..."
    echo "Communication applications ..."
    flatpak install -y --system \
        com.discordapp.Discord \
        com.slack.Slack \
        org.signal.Signal \
        org.telegram.desktop

    echo "Gaming applications ..."
    flatpak install -y --system \
        org.polymc.PolyMC \
        com.valvesoftware.Steam

    case "$profile" in
        aurora)
            echo "Installing KDE (aurora) Flatpaks..."
            flatpak install -y --system \
                org.kde.kalk \
                org.kde.gwenview \
                org.kde.kontact \
                org.kde.okular \
                org.kde.kweather \
                org.kde.kclock \
                org.kde.haruna \
                org.kde.skanpage \
                runtime/org.gtk.Gtk3theme.Breeze
            ;;
        bluefin)
            echo "Installing GNOME (bluefin) Flatpaks..."
            flatpak install -y --system \
                org.gnome.baobab \
                org.gnome.Calculator \
                org.gnome.Calendar \
                org.gnome.Characters \
                org.gnome.Evince \
                org.gnome.Firmware \
                org.gnome.font-viewer \
                org.gnome.Logs \
                org.gnome.Loupe \
                org.gnome.NautilusPreviewer \
                org.gnome.seahorse.Application \
                org.gnome.TextEditor \
                org.gnome.Weather \
                com.mattjakeman.ExtensionManager
            ;;
        *)
            echo "Unknown profile '$profile' - no profile-specific installs performed."
            ;;
    esac

    echo "Internet applications ..."
    flatpak install -y --system \
        com.github.micahflee.torbrowser-launcher
    if [[ "$NEED_FIREFOX_FLATPAK" == "1" ]]; then
        flatpak install -y --system org.mozilla.firefox
    fi

    echo "Multimedia applications ..."
    flatpak install -y --system \
        sh.cider.genten \
        com.spotify.Client \
        org.freedesktop.Platform.ffmpeg-full//22.08

    echo "Productivity applications ..."
    flatpak install -y --system \
        org.libreoffice.LibreOffice 
  
    echo "Utilities ..."
    flatpak install -y --system \
        com.usebottles.bottles \
        io.github.dvlv.boxbuddyrs \
        com.github.tchx84.Flatseal \
        org.fedoraproject.MediaWriter \
        io.missioncenter.MissionCenter \
        md.obsidian.Obsidian \
        net.cozic.joplin_desktop \
        org.keepassxc.KeePassXC \
        com.borgbase.Vorta
    if [[ "$NEED_BITWARDEN_FLATPAK" == "1" ]]; then
        flatpak install -y --system com.bitwarden.desktop
    fi
fi
