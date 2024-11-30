#!/bin/bash

FILE="/opt/tak/certs/cert-metadata.sh"

# Ensure the file exists before attempting to modify it
if [[ -f "$FILE" ]]; then
    # Modify COUNTRY, STATE, CITY, ORGANIZATION, and ORGANIZATIONAL_UNIT as the 'tak' user
    sudo -u $TAK_USER sed -i 's/^COUNTRY=.*$/COUNTRY=XX/' "$FILE"
    sudo -u $TAK_USER sed -i 's/^STATE=.*$/STATE=XX/' "$FILE"
    sudo -u $TAK_USER sed -i 's/^CITY=.*$/CITY=XX/' "$FILE"
    sudo -u $TAK_USER sed -i 's/^ORGANIZATION=.*$/ORGANIZATION=XX/' "$FILE"
    sudo -u $TAK_USER sed -i 's/^ORGANIZATIONAL_UNIT=.*$/ORGANIZATIONAL_UNIT=XX/' "$FILE"

    echo "Updated $FILE with 'XX' values."
else
    echo "File $FILE not found!"
    exit 1
fi

cd /opt/tak/certs

# Create CA as 'tak' user
sudo -u tak ./makeRootCa.sh

# Create server cert as 'tak' user
sudo -u tak ./makeCert.sh server takserver

# Create user cert as 'tak' user
sudo -u tak ./makeCert.sh client user

# Create admin cert as 'tak' user
sudo -u tak ./makeCert.sh client admin

# Restart takserver as root (since service control requires root)
echo "Restarting takserver service..."
sudo systemctl restart takserver

# Authorize admin.pem cert to use admin webpage UI
echo "Authorizing admin cert for web UI access..."
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem

FILE="/opt/tak/CoreConfig.xml"

# Ensure the file exists before attempting to modify it
if [[ -f "$FILE" ]]; then
    # Add auth="x509" after coreVersion="2" in the input _name="stdssl" line
    sudo -u $TAK_USER sed -i '/<input _name="stdssl"/s/\(coreVersion="2"\)/\1 auth="x509"/' "$FILE"

    echo "Updated $FILE with auth=\"x509\" in the stdssl input line."
else
    echo "File $FILE not found!"
    exit 1
fi

# Restart takserver after configuration changes
echo "Restarting takserver after configuration changes..."
sudo systemctl restart takserver

# Note on Firefox certificate installation (manual step)
echo "Please manually install the admin cert into Firefox to access the web UI on https://localhost:8443"
