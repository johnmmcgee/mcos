#!/bin/bash

profile=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
echo "Detected: $profile"

read -p "Do you want to install all system flatpaks? (y/n): " choice
if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then

    echo "Disable all repos but flathub for this install .. "
    flatpak remote-delete fedora --force || true
    flatpak remote-delete fedora-testing --force || true

    read -p "Do you want to clean and remove all current system flatpaks? (recommended for first run) (y/n): " choice
    if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then

      flatpak remove --system --noninteractive --all

    fi
    
    #sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Installing flatpaks that we wish to be system-wide..."
    echo "Communication applicatons ..."
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
          org.fedoraproject.MediaWriter \
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
      com.github.micahflee.torbrowser-launcher \
      org.mozilla.firefox

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
      io.missioncenter.MissionCenter \
      md.obsidian.Obsidian \
      net.cozic.joplin_desktop \
      org.keepassxc.KeePassXC \
      com.borgbase.Vorta

fi
