#!/bin/bash

# Javier Ferrándiz Fernández - 31/07/2023 - https://github.com/javisys

# Function to generate a random password
generate_password() {
    local length=$1
    tr -dc 'A-Za-z0-9!@#$%^&*()_+-=' < /dev/urandom | head -c "$length"
    echo
}

# Password length security levels
low_s=8
medium_s=12
high_s=16

# File name for saving passwords
output_file="passwords_generated.txt"

# Function to save the password in the file
save_passwd() {
    local level=$1
    local password=$2
    echo "Security level: $level" >> "$output_file"
    echo "Password: $password" >> "$output_file"
    echo >> "$output_file"
}

# Generate passwords of different security levels and save them to the file
echo "Generating passwords and saving them to $output_file"
echo

generate_password $low_s
save_passwd "Low" "$(generate_password $low_s)"

generate_password $medium_s
save_passwd "Medium" "$(generate_password $medium_s)"

generate_password $high_s
save_passwd "High" "$(generate_password $high_s)"

echo "Passwords generated and stored in $output_file."
