#!/bin/bash

# TAK Single Server Install Script

# Confirm readiness
echo "TAK Single Server Install"
echo "Ensure you meet the following prerequisites:"
echo "1. Logged in as your created admin user."
echo "2. Working internet connection (offline install not supported)."
echo "3. '~/cozytak' directory exists with 'install.sh', 'certs.sh', and 'takserver-x.x-RELEASE...' files."
echo "4. Run 'sudo dnf update -y' and reboot if there are kernel updates."
echo "This script is designed for fresh, updated Rocky 8 installs (may work on 9)."
read -p "Are you ready to proceed? (y/n): " ready

if [[ "$ready" != "y" ]]; then
    echo "Exiting. Ensure you meet all prerequisites before running this script."
    exit 0
fi

# Base Install
echo "Starting base installation process..."

# Verify ~/cozytak directory and required files
if [[ ! -d ~/cozytak ]] || [[ ! -f ~/cozytak/install.sh ]] || [[ ! -f ~/cozytak/certs.sh ]] || [[ ! -f ~/cozytak/takserver-*-RELEASE*.rpm ]]; then
    echo "Error: '~/cozytak' directory or required files not found. Ensure 'install.sh', 'certs.sh', and 'takserver-x.x-RELEASE...' are in '~/cozytak'."
    exit 1
fi

# Configuring multiple TCP connections
echo "Configuring system limits for multiple TCP connections..."
echo -e "* soft nofile 32768" | sudo tee --append /etc/security/limits.conf > /dev/null
echo -e "* hard nofile 32768" | sudo tee --append /etc/security/limits.conf > /dev/null

# Install EPEL repository
echo "Installing EPEL repository..."
sudo dnf install epel-release -y

# Add PostgreSQL repository and disable default module
echo "Adding PostgreSQL repository and disabling default PostgreSQL module..."
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -qy module disable postgresql

# Update system
echo "Updating the system..."
sudo dnf update -y

# Install Java
echo "Installing Java..."
sudo dnf install java-17-openjdk-devel -y

# Enable powertools repository
echo "Enabling powertools repository..."
sudo dnf config-manager --set-enabled powertools

# Install TAK Server
echo "Installing TAK Server..."
sudo dnf install ~/cozytak/takserver-*-RELEASE*.rpm -y

# Install SELinux check policy and apply SELinux configurations
echo "Applying SELinux configurations..."
sudo dnf install checkpolicy -y
cd /opt/tak && sudo ./apply-selinux.sh
sudo semodule -l | grep takserver

# Start and enable TAK Server service
echo "Starting and enabling TAK Server service..."
sudo systemctl daemon-reload
sudo systemctl start takserver
sudo systemctl enable takserver

# Copy certs.sh to /home/tak and switch to tak user
echo "Setting up certificates..."
sudo cp ~/cozytak/certs.sh /home/tak
sudo su - tak -c "/home/tak/certs.sh"

echo "TAK Server installation and setup complete."
