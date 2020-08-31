#!/usr/bin/env bash

sudo apt update -y

sudo apt install -y curl net-tools

curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -

echo "deb https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list

sudo apt update -y

sudo apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew install plexmediaserver

sudo systemctl enable plexmediaserver
sudo systemctl start plexmediaserver
