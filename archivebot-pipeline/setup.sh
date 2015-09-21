#!/bin/bash

adduser --disabled-login --gecos 'ArchiveBot' ${ARCHIVEBOT_USER}
passwd -d ${ARCHIVEBOT_USER}

apt-get update

# Archivebot
DEBIAN_FRONTEND="noninteractive" \
apt-get install -y \
  git build-essential python3-dev python3-pip libxml2-dev libxslt-dev zlib1g-dev \
  libssl-dev libsqlite3-dev libffi-dev fontconfig-config \
  fonts-dejavu-core libfontconfig1 libjpeg-turbo8 libjpeg8

# Phantomjs
DEBIAN_FRONTEND="noninteractive" \
apt-get install -y build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev

git clone git://github.com/ariya/phantomjs.git /tmp/phantomjs
cd /tmp/phantomjs
git checkout 1.9.8
./build.sh --confirm
mv /tmp/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
cd ~
rm -rf /tmp/phantomjs/

apt-get clean

cd /home/archivebot
su ${ARCHIVEBOT_USER} <<'EOF'
git clone --depth 1 https://github.com/ArchiveTeam/ArchiveBot /home/archivebot/ArchiveBot
cd /home/archivebot/ArchiveBot
git submodule update --init
pip3 install --user -r pipeline/requirements.txt

mkdir -p /home/archivebot/warcs4fos
mkdir -p /home/archivebot/logs
EOF