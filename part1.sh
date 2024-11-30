#!/bin/bash

echo "Starting Part 1: New Install - One Server"

# Install EPEL repository
echo "Installing EPEL repository..."
sudo dnf install epel-release -y > /dev/null 2>&1

# Add PostgreSQL repository and disable default module
echo "Adding PostgreSQL repository..."
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm > /dev/null 2>&1
sudo dnf -qy module disable postgresql > /dev/null 2>&1

# Update system
echo "Updating the system (this may take a while)..."
sudo dnf update -y > /dev/null 2>&1

# Install Java
echo "Installing Java..."
sudo dnf install java-17-openjdk-devel -y > /dev/null 2>&1

# Enable powertools repository
echo "Enabling powertools repository..."
sudo dnf config-manager --set-enabled powertools > /dev/null 2>&1

# Install TAK Server
echo "Installing TAK Server..."
TAKSERVER_RPM=$(find "$SCRIPT_DIR" -name "takserver-*-release*.noarch.rpm" | head -n 1)
if [[ -n "$TAKSERVER_RPM" ]]; then
    sudo dnf install "$TAKSERVER_RPM" -y > /dev/null 2>&1
else
    echo "Error: TAK Server RPM not found in $SCRIPT_DIR."
    exit 1
fi

# Apply SELinux configurations
echo "Applying SELinux configurations..."
sudo dnf install checkpolicy -y > /dev/null 2>&1
cd /opt/tak && sudo ./apply-selinux.sh > /dev/null 2>&1
sudo semodule -l | grep takserver > /dev/null 2>&1

# Start and enable TAK Server service
echo "Starting TAK Server service..."
sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl start takserver > /dev/null 2>&1
sudo systemctl enable takserver > /dev/null 2>&1

# Verify TAK Server service status
if systemctl is-active --quiet takserver; then
    echo "TAK Server is running successfully."
else
    echo "Error: TAK Server failed to start. Check logs for details."
    exit 1
fi

echo "Part 1 complete."
