#!/bin/bash
# Javier Ferrándiz Fernández
# ./portDetect <ip-address>

if [ $1 ]; then
    ip=$1
    for port in $(seq 1 65535); do
        timeout 1 bash -c echo " '' > /dev/tcp/$ip/$port" 2> /dev/null && echo "Port $port - [OPEN]" &
    done
        wait
else
    echo -e "\n[*]Usage: ./portDetect <ip-address>\n"
    exit 1
fi
