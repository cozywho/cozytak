#!/bin/bash

echo "Starting "Existing Server Upgrade - One Server""

# Install EPEL repository
echo "Verifying EPEL repository..."
sudo dnf install epel-release -y > /dev/null 2>&1

# Add PostgreSQL repository and disable default module
echo "Verifying PostgreSQL repository..."
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm > /dev/null 2>&1
sudo dnf -qy module disable postgresql > /dev/null 2>&1

# Update system
echo "Updating the system (this may take a while)..."
sudo dnf update -y > /dev/null 2>&1

# Install Java
echo "Verifying Java..."
sudo dnf install java-17-openjdk-devel -y > /dev/null 2>&1

# Enable powertools repository
echo "Verifying powertools repository is enabled..."
sudo dnf config-manager --set-enabled powertools > /dev/null 2>&1

# Install TAK Server
echo "Upgrading TAK Server..."
sudo dnf install takserver* --setopt=clean_requirements_on_remove=false -y > /dev/null 2>&1

echo "TAK server upgraded..."
