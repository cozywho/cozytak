#!/bin/bash

echo "Starting Part 1: New Install - One Server"

# Increase system limit for number of concurrent TCP connections
#echo "Increasing TCP connection system limit"
#echo -e "*		soft	nofile		32768" | sudo tee --append /etc/security/limits.conf > /dev/null
#echo -e "*		hard	nofile		32768" | sudo tee --append /etc/security/limits.conf > /dev/null

if ! grep -q "soft[[:space:]]*nofile[[:space:]]*32768" /etc/security/limits.conf; then
    echo "Increasing TCP connection system limit..."
    echo -e "*\tsoft\tnofile\t32768" | sudo tee --append /etc/security/limits.conf > /dev/null
    echo -e "*\thard\tnofile\t32768" | sudo tee --append /etc/security/limits.conf > /dev/null
else
    echo "TCP connection system limit already set."
fi

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
sudo dnf install takserver-* -y > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to install TAK Server. Exiting."
    exit 1
fi

# Apply SELinux configurations
echo "Applying SELinux configurations..."
sudo dnf install checkpolicy -y > /dev/null 2>&1
cd /opt/tak
sudo ./apply-selinux.sh && sudo semodule -l | grep takserver > /dev/null 2>&1

# Start and enable TAK Server service
echo "Starting TAK Server service..."
sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable takserver > /dev/null 2>&1 && sudo systemctl start takserver > /dev/null 2>&1

# Verify TAK Server service status
if systemctl is-active --quiet takserver; then
    echo "TAK Server is running successfully."
else
    echo "Error: TAK Server failed to start. Check logs for details."
    exit 1
fi

echo "Part 1 complete."

# --------------------------------
# PART 2: CERT GENERATION & CONFIG
# --------------------------------

FILE="/opt/tak/certs/cert-metadata.sh"

# Ensure the file exists before attempting to modify it
if [[ -f "$FILE" ]]; then
    # Modify COUNTRY, STATE, CITY, ORGANIZATION, and ORGANIZATIONAL_UNIT as the 'tak' user
    sudo -u tak sed -i 's/^COUNTRY=.*$/COUNTRY=XX/' "$FILE"
    sudo -u tak sed -i 's/^STATE=.*$/STATE=XX/' "$FILE"
    sudo -u tak sed -i 's/^CITY=.*$/CITY=XX/' "$FILE"
    sudo -u tak sed -i 's/^ORGANIZATION=.*$/ORGANIZATION=XX/' "$FILE"
    sudo -u tak sed -i 's/^ORGANIZATIONAL_UNIT=.*$/ORGANIZATIONAL_UNIT=XX/' "$FILE"

    echo "Updated $FILE"
else
    echo "File $FILE not found!"
    exit 1
fi

cd /opt/tak/certs

# Create CA as 'tak' user
echo "Creating Root CA"
sudo -u tak ./makeRootCa.sh </dev/null > /dev/null 2>&1

# Create server cert as 'tak' user
echo "Creating server cert."
sudo -u tak ./makeCert.sh server takserver > /dev/null 2>&1

# Create user cert as 'tak' user
echo "Creating user cert."
sudo -u tak ./makeCert.sh client user > /dev/null 2>&1

# Create admin cert as 'tak' user
echo "Creating admin cert."
sudo -u tak ./makeCert.sh client admin > /dev/null 2>&1

# Restart takserver as root (since service control requires root)
echo "Restarting takserver."
sudo systemctl restart takserver > /dev/null 2>&1

# Modifying CoreConfig.xml
echo "Modifying CoreConfig.xml"
sudo -u tak sed -i '/<input _name="stdssl"/s/\(coreVersion="2"\)/\1 auth="x509"/' "/opt/tak/CoreConfig.xml" > /dev/null

# Restart takserver after configuration changes
echo "Restarting takserver."
sudo systemctl restart takserver > /dev/null 2>&1
echo "Execute that stupid fucking java command first."
echo "Then manually install the admin cert into Firefox to access the web UI on https://localhost:8443"
# sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem

# Store script directory value
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy admin cert to cozytak folder for user to import.
# sudo cp /opt/tak/certs/files/admin.pem "$SCRIPT_DIR/admin.pem" && sudo chown $(whoami):$(whoami) "$SCRIPT_DIR/admin.pem"
# sudo cp /opt/tak/certs/files/admin.p12 "$SCRIPT_DIR/admin.p12" && sudo chmod 777 "$SCRIPT_DIR/admin.p12" 
