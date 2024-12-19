#!/bin/bash

echo "Starting New Install - One Server"

# Increase system limit for number of concurrent TCP connections
echo "Increasing TCP connection system limit"
echo -e "*		soft	nofile		32768" | sudo tee --append /etc/security/limits.conf > /dev/null
echo -e "*		hard	nofile		32768" | sudo tee --append /etc/security/limits.conf > /dev/null

# Install EPEL repository
echo "Installing EPEL repository..."
sudo dnf install epel-release -y > /dev/null 2>&1

# Add PostgreSQL repository and disable default module
echo "Adding PostgreSQL repository..."
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm > /dev/null 2>&1
sudo dnf -qy module disable postgresql && sudo dnf update -y > /dev/null 2>&1

# Install Java
echo "Installing Java..."
sudo dnf install java-17-openjdk-devel -y > /dev/null 2>&1

# Enable powertools repository
echo "Enabling powertools repository..."
sudo dnf config-manager --set-enabled powertools > /dev/null 2>&1

# Install TAK Server
echo "Installing TAK Server..."
sudo dnf install takserver-* -y > /dev/null 2>&1

# Apply SELinux configurations
echo "Applying SELinux configurations..."
sudo dnf install checkpolicy > /dev/null 2>&1
cd /opt/tak
sudo ./apply-selinux.sh && sudo semodule -l | grep takserver > /dev/null 2>&1

# Start and enable TAK Server service
echo "Starting TAK Server service..."
sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable takserver && sudo systemctl start takserver > /dev/null 2>&1

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
sudo -u tak ./makeRootCa.sh </dev/null >/dev/null 2>&1

# Create server cert as 'tak' user
echo "Creating server cert."
sudo -u tak ./makeCert.sh server takserver

# Create user cert as 'tak' user
echo "Creating user cert."
sudo -u tak ./makeCert.sh client user

# Create admin cert as 'tak' user
echo "Creating admin cert."
sudo -u tak ./makeCert.sh client admin

# Restart takserver as root (since service control requires root)
echo "Restarting takserver."
sudo systemctl restart takserver

FILE="/opt/tak/CoreConfig.xml"

# Ensure the file exists before attempting to modify it
if [[ -f "$FILE" ]]; then
    # Add auth="x509" after coreVersion="2" in the input _name="stdssl" line
    sudo -u tak sed -i '/<input _name="stdssl"/s/\(coreVersion="2"\)/\1 auth="x509"/' "$FILE"

    echo "Updated $FILE"
else
    echo "File $FILE not found!"
    exit 1
fi

# Restart takserver after configuration changes
echo "Restarting takserver."
sudo systemctl restart takserver

cd /home/gsu-admin/cozytak/

sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem

# Store script directory value
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy admin cert to cozytak folder for user to import.
# sudo cp /opt/tak/certs/files/admin.pem "$SCRIPT_DIR/admin.pem" && sudo chown $(whoami):$(whoami) "$SCRIPT_DIR/admin.pem"
sudo cp /opt/tak/certs/files/admin.p12 "$SCRIPT_DIR/admin.p12" && sudo chmod 777 "$SCRIPT_DIR/admin.p12" 

# Note on Firefox certificate installation (manual step)
echo "Please manually install the admin.p12 cert into Firefox to access the web UI."
echo "Located at $SCRIPT_DIR/admin.p12"
echo ""
echo "https://localhost:8443"
echo ""
echo "Install complete."
