benchmark:
  echo 'Running a 1 minute benchmark ...'
  stress-ng --matrix 0 -t 1m --times

# Assemble distrobox containers
assemble:
  echo 'Assembling and replacing distroboxes ...'
  distrobox assemble create --replace --file /etc/distrobox/distrobox.ini

distrobox-fedora
  echo "create intial distrobox environment"
  distrobox create --nvidia --image ghcr.io/ublue-os/fedora-distrobox:latest -n fedora -Y -ap "buildah butane highlight just kitty lsd stow tmux vim xclip wl-clipboard zsh"