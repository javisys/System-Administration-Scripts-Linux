#!/bin/bash

# Javier Ferrándiz Fernández - 27/07/2023 - https://github.com/javisys

# Directory to organize
src_dir="$HOME"

# Function to move files to their respective subfolders
organize_files() {
    local file="$1"
    local file_type

    # Get the file type using the "file" command
    file_type=$(file -b --mime-type "$file")

    # Removing blanks from the file type
    file_type=$(echo "$file_type" | tr -d '[:space:]')

    case "$file_type" in
        image/*)
            dest_dir="$src_dir/images"
            ;;
        audio/*)
            dest_dir="$source_dir/music"
            ;;
        video/*)
            dest_dir="$source_dir/videos"
            ;;
        application/pdf)
            dest_dir="$source_dir/documents"
            ;;
        Otros)
            dest_dir="$source_dir/others"
            ;;
        q)
            exit 0
            ;;
        *)
            echo "You have not chosen any function"
            exit 1
            ;;
    esac

    # Create the destination folder if it does not exist
    [ ! -d "$dest_dir" ] &&  mkdir -p "$dest_dir"

    # Move the file to the destination folder
    mv "$file" "$dest_dir/"
}

# Check if the source directory exists
if [ ! -d "$src_dir" ];
then
    echo "The source directory does not exist."
    exit 1
fi

# Moving files to subfolders according to their type
find "$src_dir" -type f -print0 | while IFS= read -r -d '' file;
do
    organize_files "$file"
done

echo "The organization has been completed."