#!/bin/bash
set -e
apt-get update
apt-get install -y curl

# Update steam - have to do all this stuff because the filename is always the same.
# There's probably a better way to do this.
curl -LO https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
if ! cmp --silent "./steam.deb" "/repo/steam.deb"; then
    curl -L https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -o /repo/steam.deb
fi

# Update ArmCord
cd /repo
curl -LO $(curl -s https://api.github.com/repos/ArmCord/ArmCord/releases/latest | grep "browser_download_url.*ArmCord_.*_amd64.deb" | cut -d : -f 2,3 | tr -d \") -C -
cd /drone/src

dpkg-scanpackages --arch amd64 /repo > /repo/Packages
cat /repo/Packages | gzip -9 > /repo/Packages.gz