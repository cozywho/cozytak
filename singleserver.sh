#!/bin/bash

echo "Starting Single Server Install..."

# Check OS type
OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
fi

if [ "$OS" == "ubuntu" ]; then
    echo "Detected OS: Ubuntu"

    if ! grep -q "soft[[:space:]]*nofile[[:space:]]*32768" /etc/security/limits.conf; then
        echo "Increasing TCP connection system limit..."
        echo -e "*\tsoft\tnofile\t32768" | sudo tee --append /etc/security/limits.conf > /dev/null
        echo -e "*\thard\tnofile\t32768" | sudo tee --append /etc/security/limits.conf > /dev/null
    else
        echo "TCP connection system limit already set."
    fi

    # Ubuntu specific commands
    echo "Installing PostgreSQL repo..."
    sudo mkdir -p /etc/apt/keyrings
    sudo curl https://www.postgresql.org/media/keys/ACCC4CF8.asc --output /etc/apt/keyrings/postgresql.asc > /dev/null 2>&1
    sudo sh -c 'echo "deb [signed-by=/etc/apt/keyrings/postgresql.asc] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/postgresql.list'
    echo "Updating system..."
    sudo apt update > /dev/null 2>&1
    echo "Installing TAK Server..."
    sudo apt install -y /opt/cozytak/takserver_*.deb > /dev/null 2>&1

elif [ "$OS" == "rocky" ] && [[ "$VERSION" == 8* ]]; then
    echo "Detected OS: Rocky Linux 8"

    if ! grep -q "soft[[:space:]]*nofile[[:space:]]*32768" /etc/security/limits.conf; then
        echo "Increasing TCP connection system limit..."
        echo -e "*\tsoft\tnofile\t32768" | sudo tee --append /etc/security/limits.conf > /dev/null
        echo -e "*\thard\tnofile\t32768" | sudo tee --append /etc/security/limits.conf > /dev/null
    else
        echo "TCP connection system limit already set."
    fi

    # Rocky specific commands
    echo "Installing EPEL..."
    sudo dnf install epel-release -y > /dev/null 2>&1

    echo "Adding PostgreSQL..."
    sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm > /dev/null 2>&1
    sudo dnf -qy module disable postgresql > /dev/null 2>&1

    echo "Updating system..."
    sudo dnf update -y > /dev/null 2>&1

    echo "Installing Java..."
    sudo dnf install java-17-openjdk-devel -y > /dev/null 2>&1

    echo "Enabling powertools repository..."
    sudo dnf config-manager --set-enabled powertools > /dev/null 2>&1

    echo "Installing TAK Server..."
    sudo dnf install /opt/cozytak/takserver-* -y > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install TAK Server. Exiting."
        exit 1
    fi
else
    echo "Unsupported OS or version. Exiting."
    exit 1
fi

# Common commands for both Ubuntu and Rocky after daemon reload
echo "Starting TAK Server service..."
sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable takserver > /dev/null 2>&1 && sudo systemctl start takserver > /dev/null 2>&1

if systemctl is-active --quiet takserver; then
    echo "TAK Server is running successfully..."
else
    echo "Error: TAK Server failed to start. Check logs for details."
    exit 1
fi

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
echo "Creating Root CA..."
sudo -u tak ./makeRootCa.sh </dev/null > /dev/null 2>&1

# Create server cert as 'tak' user
echo "Creating server cert..."
sudo -u tak ./makeCert.sh server takserver > /dev/null 2>&1

# Create user cert as 'tak' user
echo "Creating user cert..."
sudo -u tak ./makeCert.sh client user > /dev/null 2>&1

# Create admin cert as 'tak' user
echo "Creating admin cert..."
sudo -u tak ./makeCert.sh client admin > /dev/null 2>&1

# Restart takserver as root (since service control requires root)
echo "Restarting takserver..."
sudo systemctl restart takserver > /dev/null 2>&1

sleep 10
# Modifying CoreConfig.xml
echo "Modifying CoreConfig.xml..."
sudo -u tak sed -i '/<input _name="stdssl"/s/\(coreVersion="2"\)/\1 auth="x509"/' "/opt/tak/CoreConfig.xml" > /dev/null

# ADD A PORTION HERE ABOUT MODIFYING THE DEFAULT PASSWORD

# Restart takserver after configuration changes
echo "Restarting takserver..."
sudo systemctl restart takserver > /dev/null 2>&1

#echo "Move /opt/tak/certs/files/admin.p12 to cozytak."
#echo "Then manually install the admin cert into Firefox to access the web UI on https://localhost:8443"
sleep 60
cd /opt/tak/
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem > /dev/null 2>&1
cd /opt/cozytak/
# Store script directory value
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo "Do that stupid fucking java command in the readme, i cant figure out how to get it to work inside the script."
echo "Copy admin.p12 cert and import into your browser, then access @ https://localhost:8443."
# sudo cp /opt/tak/certs/files/admin.pem "$SCRIPT_DIR/admin.pem" && sudo chown $(whoami):$(whoami) "$SCRIPT_DIR/admin.pem"
# sudo cp /opt/tak/certs/files/admin.p12 "$SCRIPT_DIR/admin.p12" && sudo chmod 777 "$SCRIPT_DIR/admin.p12" 
