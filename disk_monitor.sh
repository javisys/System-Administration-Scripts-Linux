#!/bin/bash

# Javier Ferrándiz Fernández - 27/07/2023 - https://github.com/javisys

# Disk space threshold (in percent)
threshold=80

# Function to send a notification by mail
send_notification() {
    local subject="Alert: Disk space critically low"
    local message="Disk space reached the threshold of $threshold%.\n\n"
    local total_space=$(df -BG --output=avail / | awk 'NR==2 {print $1}')
    local used_space=$(df -BG --output=pcent / | awk 'NR==2 {print $1}')
    message+="Total space available: ${total_space}GB\n"
    message+="Space used: ${used_space}%\n"

    echo -e "$message" | mail -s "$subject" your_mail@example.com
}

# Function to check disk space and send a notification if necessary
check_disk_space() {
    local total_space=$(df -BG --output=avail / | awk 'NR==2 {print $1}' | sed 's/G//')
    local used_space=$(df -BG --output=pcent / | awk 'NR==2 {print $1}' | sed 's/%//')

    if [ "$used_space" -ge "$thresold" ];
    then
        echo "Warning! Disk space reached the threshold of $thresold%"
        echo "Total space available: ${total_space}GB"
        echo "Space used: ${used_space}%"
        send_notification
    else
        echo "Disk space: ${used_space}%. All in order."
    fi
}

# Time interval for checking disk space (in seconds)
check_interval=3600

# Infinite loop to monitor disk space periodically
while true;
do
    check_disk_space
    sleep "check_interval"
done