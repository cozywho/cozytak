#!/bin/bash
# Prompt for username
read -p "Enter username for the cert: " USERNAME
# Check for duplicate username
    if [ -e "opt/tak/certs/files/$USERNAME.p12" ]; then
        echo "A certificate for '$USERNAME' already exists. Please choose another username."
    else
        break
    fi
done

# Generate the certificate
./opt/tak/certs/makeCert.sh "$USERNAME"

# Check if the .p12 file was successfully created
if [ ! -e "opt/tak/certs/files/$USERNAME.p12" ]; then
    echo "Error: Certificate generation failed for '$USERNAME'."
    exit 1
fi

mkdir /opt/cozytak/certs/$USERNAME

# Copy the required files to the user's folder
sudo cp "opt/tak/certs/files/$USERNAME.p12" "/opt/cozytak/certs/$USERNAME/"
sudo cp "opt/tak/certs/files/truststore-root.p12" "/opt/cozytak/certs/$USERNAME/"



# Create a zip file of the user's cert folder
ZIP_FILE="$COZYTAK_CERTS_DIR/$USERNAME.zip"
zip -r "/opt/cozytak/certs/$USERNAME.zip" "/opt/cozytak/certs/$USERNAME"

# Notify the admin
if [ -e "$ZIP_FILE" ]; then
    echo "Certificate package is ready at: $ZIP_FILE"
else
    echo "Error: Failed to create certificate package."
    exit 1
fi

