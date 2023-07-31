#!/bin/bash

# Javier Ferrándiz Fernández - 31/07/2023 - https://github.com/javisys

dir="$HOME"

# Create a temporary file for storing the list of files and their hashes
tmp_file="/tmp/duplicate_files.tmp"

# Function to calculate the MD5 hash of a file
calculate_md5() {
    md5sum "$1" | awk '{print $1}'
}

# Loop to generate the list of files and their hashes
find "$dir" -type f -print0 | while IFS= read -r -d '' file; do
    calculate_md5 "$file" >> "$tmp_file"
    echo "$file" >> "$tmp_file"
done

# Identify duplicate files
duplicates=$(sort "$tmp_file" | uniq -d --all-repeated=separate | awk 'NR % 2 == 0')

# Show duplicate files and allow user to choose what to do
if [ -n "$duplicates" ];
then
    echo "Duplicate files have been found:"
    echo "$duplicates"
    echo
    echo "What do you want to do with duplicate files?"
    echo "1.- Delete all duplicates"
    echo "2.- Keep only one file from each set of duplicates"
    echo "3.- Do nothing (leave without changes)"

    read -p "Select an option: " option

    case "$option" in
        1)
            echo "$duplicates" | xargs rm
            echo "Duplicate files deleted."
            ;;
        2)
            echo "$duplicates" | uniq -u --all-repeated=separate | xargs rm
            echo "Duplicate files deleted, only one file from each set was retained."
            ;;
        3)
            echo "No changes were made. Duplicate files are maintained."
            ;;
        *)
            echo "Invalid option. No changes were made."
            ;;
    esac
else
    echo "No duplicate files were found in the specified directory"
fi

# Delete temporary file
rm "$tmp_file"