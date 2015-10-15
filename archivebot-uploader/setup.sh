#!/bin/bash

apt-get update
DEBIAN_FRONTEND="noninteractive" \
apt-get install -y \
  build-essential python3-dev python3-pip libxml2-dev libxslt-dev zlib1g-dev \
  libssl-dev libsqlite3-dev libffi-dev git tmux fontconfig-config \
  fonts-dejavu-core libfontconfig1 libjpeg-turbo8 libjpeg8

adduser --disabled-login --gecos 'ArchiveBot' ${ARCHIVEBOT_USER}
passwd -d ${ARCHIVEBOT_USER}

cd /home/archivebot

su ${ARCHIVEBOT_USER} <<'EOF'
git clone --depth 1 https://github.com/ArchiveTeam/ArchiveBot /home/archivebot/ArchiveBot
cd /home/archivebot/ArchiveBot
git submodule update --init
pip3 install --user -r pipeline/requirements.txt
EOF

DEBIAN_FRONTEND="noninteractive" \
apt-get purge -y build-essential

DEBIAN_FRONTEND="noninteractive" \
apt-get autoremove -y

apt-get clean
