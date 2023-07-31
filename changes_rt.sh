#!/bin/bash

# Javier Ferrándiz Fernández - 31/07/2023 - https://github.com/javisys

# We will use the inotifywait command, which is a tool that can observe changes to files and directories in real time.
# Make sure you have inotify-tools installed on your system before running the script.

# Directory to watch
dir_to_watch="$HOME"

# Time in seconds to observe changes
observation_period=300

# Log file to store changes
log_file="changes.log"

# Function to observe changes in the directory
observe_changes() {
    inotifywait -r -m -e modify,create,delete,move "$dir_to_watch" |
    while read -r directory event file;
    do
        echo "$(date +"%Y-%m-%d %H:%M:%S") - Event: $event - File: $directory$file" >> "$log_file"
    done
}

# Check if the directory exists
if [ ! -d "$dir_to_watch" ];
then
    echo "The directory $dir_to_watch does not exist."
    exit 1
fi

# Execute the function to observe changes in the directory
observe_changes &

# Waiting for observation time
sleep "$observation_period"

# End the observation after the observation time
pkill -P $$ inotifywait

echo "Observation completed. Changes have been recorded in $log_file."
