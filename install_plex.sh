#!/usr/bin/env bash
sudo apt install wget -y
wget https://downloads.plex.tv/plex-media-server-new/1.19.3.2852-219a9974e/debian/plexmediaserver_1.19.3.2852-219a9974e_amd64.deb -O /tmp/plex.deb

sudo dpkg -i /tmp/plex.deb

sudo systemctl enable plexmediaserver
sudo systemctl start plexmediaserver

