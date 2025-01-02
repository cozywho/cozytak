#!/bin/bash
# Prompt for username
read -p "Enter username for the cert: " USERNAME
# Check for duplicate username
    if [ -e "/opt/tak/certs/files/$USERNAME.p12" ]; then
        echo "A certificate for '$USERNAME' already exists. Please choose another username."
    else
        break
    fi
done

# Generate the certificate
sudo -u tak ./opt/tak/certs/makeCert.sh "$USERNAME"

# Check if the .p12 file was successfully created
if [ ! -e "/opt/tak/certs/files/$USERNAME.p12" ]; then
    echo "Error: Certificate generation failed for '$USERNAME'."
    exit 1
fi

mkdir /opt/cozytak/certs/$USERNAME

# Copy the required files to the user's folder
touch 
sudo cp "/opt/tak/certs/files/$USERNAME.p12" "/opt/cozytak/certs/$USERNAME/"
sudo cp "/opt/tak/certs/files/truststore-root.p12" "/opt/cozytak/certs/$USERNAME/"
touch /opt/cozytak/certs/$USERNAME/manifest.xml
touch /opt/cozytak/certs/$USERNAME/package_builder.pref

#manifest.xml
manifest="/opt/cozytak/certs/$USERNAME/manifest.xml"
{
    echo "<?xml version=\"1.0\" standalone=\"yes\"?>"
    echo "<MissionPackageManifest version=\"2\">"
    echo "  <Configuration>"
    echo "    <Parameter name=\"name\" value=\"localhost\" />"
    echo "    <Parameter name=\"uid\" value=\"78f3ce32-2d11-4b6e-a668-77551aa081f6\" />"
    echo "  </Configuration>"
    echo "  <Contents>"
    echo "    <Content zipEntry=\"user.p12\" ignore=\"false\" />"
    echo "    <Content zipEntry=\"truststore-root.p12\" ignore=\"false\" />"
    echo "    <Content zipEntry=\"package_builder.pref\" ignore=\"false\" />"
    echo "  </Contents>"
    echo "</MissionPackageManifest>"
} > "$conf_file"

#variables
$HOSTNAME
$IPADDY
$USERNAME
$PASSWORD

#packagebuilder.pref
package_builder="/opt/cozytak/certs/$USERNAME/package_builder.pref"
{
    echo "<?xml version='1.0' standalone='yes'?>"
    echo "<preferences>"
    echo "<preference version=\"1\" name=\"cot_streams\">"
    echo "<entry key=\"count\" class=\"class java.lang.Integer\">1</entry>"
    echo "<entry key=\"description0\" class=\"class java.lang.String\">$HOSTNAME</entry>"
    echo "<entry key=\"enabled0\" class=\"class java.lang.Boolean\">true</entry>"
    echo "<entry key=\"connectString0\" class=\"class java.lang.String\">$IPADDY:8089:ssl</entry>"
    echo "</preference>"
    echo "<preference version=\"1\" name=\"com.atakmap.app_preferences\">"
    echo "<entry key=\"caLocation\" class=\"class java.lang.String\">cert/truststore-root.p12</entry>"
    echo "<entry key=\"certificateLocation\" class=\"class java.lang.String\">cert/$USERNAME.p12</entry>"
    echo "<entry key=\"clientPassword\" class=\"class java.lang.String\">$PASSWORD</entry>"
    echo "<entry key=\"caPassword\" class=\"class java.lang.String\">$PASSWORD</entry>"
    echo "<entry key=\"displayServerConnectionWidget\" class=\"class java.lang.Boolean\">true</entry>"
    echo "</preference>"
    echo "<preference version=\"1\" name=\"mil.afrl.risd.android.ATAK_preferences\">"
    echo "</preference>"
    echo "</preferences>"
} > "$conf_file"



# Create a zip file of the user's cert folder
ZIP_FILE="$COZYTAK_CERTS_DIR/$USERNAME.zip"
zip -r "/opt/cozytak/certs/$USERNAME.zip" "/opt/cozytak/certs/$USERNAME"


echo "--------------------------------------------------"
echo "$USERNAME package created in /opt/cozytak/certs."
echo "--------------------------------------------------"

# Notify the admin
if [ -e "$ZIP_FILE" ]; then
    echo "Certificate package is ready at: $ZIP_FILE"
else
    echo "Error: Failed to create certificate package."
    exit 1
fi

