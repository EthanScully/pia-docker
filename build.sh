#!/bin/bash
set -eu

if [ "$1" = "linux/arm64" ]; then
    PIAURL="https://installers.privateinternetaccess.com/download/pia-linux-arm64-3.6.1-08339.run"
elif [ "$1" = "linux/amd64" ]; then
    PIAURL="https://installers.privateinternetaccess.com/download/pia-linux-3.6.1-08339.run"
else
    echo "Unsupported platform: $1"
    exit 1
fi

apt update
apt install curl systemctl sudo libglib2.0-0 iproute2 libatomic1 libnl-utils -y
useradd -m -s /bin/bash pia
usermod -aG sudo pia
echo "pia ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
sudo -u pia bash -c "
    cd
    curl "$PIAURL" -o pia.run
    bash pia.run
"
#cleanup
apt clean
rm -rf /var/lib/apt/lists/*
