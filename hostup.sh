#!/bin/bash
# Javier Ferrándiz Fernández
# Script to detect running machines on a network segment.

for i in $(seq 2 254); do
    # This script is done for 10.10.10.x segment
    timeout 1 bash -c "ping -c 1 10.10.10.$i > /dev/null 2>&1" && echo "Host 10.10.10.$i - ACTIVE" & 
done; wait 