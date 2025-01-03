#!/bin/bash

# Prompt for username
read -p "Enter username for the cert: " USERNAME

# Check for duplicate username
if [ -e "/opt/tak/certs/files/$USERNAME.p12" ]; then
    echo "A certificate for '$USERNAME' already exists. Please choose another username."
    exit 1
fi

# Generate the certificate
cd /opt/tak/certs
sudo -u tak ./makeCert.sh client "$USERNAME"
cd /opt/cozytak

# Check if the .p12 file was successfully created
if [ ! -e "/opt/tak/certs/files/$USERNAME.p12" ]; then
    echo "Error: Certificate generation failed for '$USERNAME'."
    exit 1
fi

# Create the user's certificate directory
USER_CERT_DIR="/opt/cozytak/certs/$USERNAME"
mkdir -p "$USER_CERT_DIR"

# Copy the required files to the user's folder
sudo cp "/opt/tak/certs/files/$USERNAME.p12" "$USER_CERT_DIR/$USERNAME.p12"
sudo cp "/opt/tak/certs/files/truststore-root.p12" "$USER_CERT_DIR/"
touch "$USER_CERT_DIR/manifest.xml" "$USER_CERT_DIR/package_builder.pref"

# Create manifest.xml
manifest="$USER_CERT_DIR/manifest.xml"
cat <<EOF > "$manifest"
<?xml version="1.0" standalone="yes"?>
<MissionPackageManifest version="2">
  <Configuration>
    <Parameter name="name" value="localhost" />
    <Parameter name="uid" value="78f3ce32-2d11-4b6e-a668-77551aa081f6" />
  </Configuration>
  <Contents>
    <Content zipEntry="$USERNAME.p12" ignore="false" />
    <Content zipEntry="truststore-root.p12" ignore="false" />
    <Content zipEntry="package_builder.pref" ignore="false" />
  </Contents>
</MissionPackageManifest>
EOF

# Define dynamic variables
HOSTNAME=$(hostname)
IPADDY=$(hostname -I | awk '{print $1}') # Grabs the first IP from the list
PASSWORD="atakatak"

# Create package_builder.pref
package_builder="$USER_CERT_DIR/package_builder.pref"
cat <<EOF > "$package_builder"
<?xml version="1.0" standalone="yes"?>
<preferences>
  <preference version="1" name="cot_streams">
    <entry key="count" class="class java.lang.Integer">1</entry>
    <entry key="description0" class="class java.lang.String">$HOSTNAME</entry>
    <entry key="enabled0" class="class java.lang.Boolean">true</entry>
    <entry key="connectString0" class="class java.lang.String">$IPADDY:8089:ssl</entry>
  </preference>
  <preference version="1" name="com.atakmap.app_preferences">
    <entry key="caLocation" class="class java.lang.String">cert/truststore-root.p12</entry>
    <entry key="certificateLocation" class="class java.lang.String">cert/$USERNAME.p12</entry>
    <entry key="clientPassword" class="class java.lang.String">$PASSWORD</entry>
    <entry key="caPassword" class="class java.lang.String">$PASSWORD</entry>
    <entry key="displayServerConnectionWidget" class="class java.lang.Boolean">true</entry>
  </preference>
  <preference version="1" name="mil.afrl.risd.android.ATAK_preferences" />
</preferences>
EOF

# Create a zip file of the user's cert folder
cd /opt/cozytak/certs
sudo zip -r "$USERNAME.zip" "$USERNAME" >/dev/null

# Notify the admin
echo "$USERNAME".zip created in /opt/cozytak/certs
