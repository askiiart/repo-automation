#!/bin/bash
set -e
apt-get update
apt-get install -y curl
apt-get install -y dpkg-dev

# Update steam - have to do all this stuff because the filename is always the same.
# There's probably a better way to do this.
# Update: This is pretty much just a deb file to install a repo, so it can't be part of my repo
#curl -LO https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
#if ! cmp --silent "./steam.deb" "/repo/steam.deb"; then
#    curl -L https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb -o /repo/steam.deb
#fi

# Update ArmCord
cd /repo/dists/bookworm/stable/binary-amd64/
curl -LO $(curl -s https://api.github.com/repos/ArmCord/ArmCord/releases/latest | grep "browser_download_url.*ArmCord_.*_amd64.deb" | cut -d : -f 2,3 | tr -d \") -C -
cd /drone/src

# Update Discord
# Has to be manually updated for each version
cd /repo/dists/bookworm/stable/binary-amd64/
curl -LO https://dl.discordapp.net/apps/linux/0.0.29/discord-0.0.29.deb -C -
cd /drone/src

# Update th-ch/youtube-music
cd /repo/dists/bookworm/stable/binary-amd64/
curl -LO $(curl -s https://api.github.com/repos/th-ch/youtube-music/releases/latest | grep "browser_download_url.*youtube-music_.*_amd64.deb" | cut -d : -f 2,3 | tr -d \") -C -
cd /drone/src

# Do repo stuff
cd /repo
dpkg-scanpackages --arch amd64 dists/bookworm/stable/binary-amd64/ > dists/bookworm/stable/binary-amd64/Packages
cat dists/bookworm/stable/binary-amd64/Packages | gzip -9 > dists/bookworm/stable/binary-amd64/Packages.gz
mv /drone/src/generate-Release.sh .
./dists/bookworm/stable/binary-amd64/generate-Release.sh > Release