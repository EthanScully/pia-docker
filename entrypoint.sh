#!/bin/bash
set -eo pipefail
# create tunnel device
if [ ! -e /dev/net/tun ]; then
    sudo mkdir -p /dev/net
    sudo mknod /dev/net/tun c 10 200
    sudo chmod 600 /dev/net/tun
fi
# Setup Logs
sudo mkdir -p /var/log/pia
# Start PIA Service as root
export LD_LIBRARY_PATH="/opt/piavpn/lib:$LD_LIBRARY_PATH"
daemonize \
  -o /var/log/pia/pia-stdout.log \
  -e /var/log/pia/pia-stderr.log \
  /bin/unbuffer /opt/piavpn/bin/pia-daemon
# create loginfile from ENV
mkdir "$HOME/.pia"
echo -e "$USER\n$PASS" >"$HOME/.pia/cred.txt"
# enable PIA
while true; do
    if piactl background enable; then
        break
    fi
    echo "failed enableling PIA, retrying..." >&2
    sleep 1
done
# PIA login
set +e
while true; do
    out="$(piactl login "$HOME/.pia/cred.txt" 2>&1)"
    ec=$?
    if [ $ec -eq 0 ] || [[ $out == *"$USER"* ]]; then
        break
    fi
    echo "failed to login into PIA: $out, retrying..." >&2
    sleep 1
done
set -e
# PIA Enable Port Fowarding
while true; do
    if piactl set requestportforward true; then
        break
    fi
    echo "failed to enable PIA port fowarding, retrying..." >&2
    sleep 1
done
# change PIA protocol
if [[ "$PROTO" == "openvpn" ]]; then
    PROTOCOL="openvpn"
else
    PROTOCOL="wireguard"
fi
while true; do
    if piactl set protocol "$PROTOCOL"; then
        break
    fi
    echo "failed to PIA protocol to $PROTOCOL, retrying..." >&2
    sleep 1
done
# PIA connect
while true; do
    if piactl connect; then
        break
    fi
    echo "failed to connect to PIA, retrying..." >&2
    sleep 1
done
# Wait for PIA to fully connect
while true; do
    code=$(curl -s -o /dev/null -w "%{http_code}" http://1.1.1.1/)
    if [ "$code" -eq 301 ]; then
        break
    fi
    sleep 0.1
done
# Transfer Control to CMD
if [ -z "$1" ]; then
    exec bash
else
    exec "$@"
fi
