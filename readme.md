### Use Private Internet Access inside a Docker Container
Based on debian:stable-slim, use this image as you would debian:stable-slim

usage:
```Shell
docker run \
    --cap-add NET_ADMIN \
    --cap-add SYS_PTRACE \
    -e USER=<username> \
    -e PASS=<password> \
    -it ethanscully/pia
```

optional ENV var: `PROTO=openvpn`, wireguard is default

optional ENV var: `REGION=auto`, auto is default
auto doesn't seem to work very well