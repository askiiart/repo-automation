#!/bin/bash
apt-get update
apt-get install -y curl
apt-get install -y createrepo-c

cd /repo
curl $(curl -s https://api.github.com/repos/ArmCord/ArmCord/releases/latest | grep "browser_download_url.*ArmCord-.*.x86_64.rpm" | cut -d : -f 2,3 | tr -d \") -LO -C -
curl $(curl -s https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | grep "browser_download_url.*.x86_64.rpm" | cut -d : -f 2,3 | tr -d \") -LO -C -
curl $(curl -s https://api.github.com/repos/th-ch/youtube-music/releases/latest | grep "browser_download_url.*youtube-music.*.x86_64.rpm" | cut -d : -f 2,3 | tr -d \") -LO -C -

createrepo_c .