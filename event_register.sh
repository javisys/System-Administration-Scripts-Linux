#!/bin/bash

# Javier Ferrándiz Fernández - 31/07/2023 - https://github.com/javisys

# E-mail address to receive notifications
email="your_email@example.com"

# Function for configuring audit rules
configure_audit_rules() {
    # Create a custom rule file
    cat << EOF > /etc/audit/rules.d/custom.rules
    # Monitor system restarts
    -a always,exit -F arch=b64 -S reboot -k system_reboot
    -a always,exit -F arch=b32 -S reboot -k system_reboot

    # Monitor user logins
    -w /var/run/utmp -p wa -k login_events

    # Monitor changes in important files (adjust paths according to your needs)
    -w /etc/passwd -p wa -k passwd_changes
    -w /etc/shadow -p wa -k shadow_changes
    -w /etc/sudoers -p wa -k sudoers_changes
EOF

    # Restart the auditd service to apply the rules
    service auditd restart
}

# Function to send notifications by e-mail
send_notification() {
    local subject="$1"
    local message="$2"
    echo -e "$message" | mail -s "$subject" "$email"
}

# Configure audit rules
configure_audit_rules

# Watch audit events in real time
echo "Monitoring system events. Press Ctrl+C to stop."
auditctl -l

# Loop to detect relevant events and send notifications by mail
while true;
do
    auditctl -a always,exit -F arch=b64 -F key=system_reboot -F dir=/var/run/utmp -p rwa
    auditctl -a always,exit -F arch=b32 -F key=system_reboot -F dir=/var/run/utmp -p rwa
    auditctl -a always,exit -F arch=b64 -F key=login_events -F dir=/etc/passwd -p rwa
    auditctl -a always,exit -F arch=b64 -F key=shadow_changes -F dir=/etc/shadow -p rwa
    auditctl -a always,exit -F arch=b64 -F key=sudoers_changes -F dir=/etc/sudoers -p rwa
    sleep 60
done
