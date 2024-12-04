#!/bin/bash

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
sudo -u tak ./makeCert.sh server takserver >/dev/null 2>&1

# Create user cert as 'tak' user
echo "Creating user cert."
sudo -u tak ./makeCert.sh client user >/dev/null 2>&1

# Create admin cert as 'tak' user
echo "Creating admin cert."
sudo -u tak ./makeCert.sh client admin >/dev/null 2>&1

# Restart takserver as root (since service control requires root)
echo "Restarting takserver."
sudo systemctl restart takserver >/dev/null 2>&1

# Authorize admin.pem cert to use admin webpage UI
echo "Authorizing admin cert for web UI access..."
cd /opt/tak/utils/
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem >/dev/null 2>&1

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

# Note on Firefox certificate installation (manual step)
echo "Please manually install the admin cert into Firefox to access the web UI on https://localhost:8443"
