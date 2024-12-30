#!/bin/bash

# Define necessary paths
CERT_DIR="/opt/tak/certs/files"
COZYTAK_DIR="$(pwd)"
COZYTAK_CERTS_DIR="$COZYTAK_DIR/certs"
DEPENDENCY_FILES=("manifest.xml" "package_builder.pref")
TRUSTSTORE_ROOT="$CERT_DIR/truststore-root.p12"

# Ensure necessary directories exist
mkdir -p "$COZYTAK_CERTS_DIR"

while true; do
    # Prompt for username
    read -p "Enter username for the cert: " USERNAME

    # Check for duplicate username
    if [ -e "$CERT_DIR/$USERNAME.p12" ]; then
        echo "A certificate for '$USERNAME' already exists. Please choose another username."
    else
        break
    fi
done

# Generate the certificate
./opt/tak/certs/makeCert.sh "$USERNAME"

# Check if the .p12 file was successfully created
if [ ! -e "$CERT_DIR/$USERNAME.p12" ]; then
    echo "Error: Certificate generation failed for '$USERNAME'."
    exit 1
fi

# Create a folder for the new cert in cozytak/certs
USER_CERT_DIR="$COZYTAK_CERTS_DIR/$USERNAME"
mkdir -p "$USER_CERT_DIR"

# Copy the required files to the user's folder
cp "$CERT_DIR/$USERNAME.p12" "$USER_CERT_DIR/"
cp "$TRUSTSTORE_ROOT" "$USER_CERT_DIR/"

for FILE in "${DEPENDENCY_FILES[@]}"; do
    if [ -e "$COZYTAK_DIR/$FILE" ]; then
        cp "$COZYTAK_DIR/$FILE" "$USER_CERT_DIR/"
    else
        echo "Warning: Dependency file '$FILE' not found in '$COZYTAK_DIR'."
    fi
done

# Create a zip file of the user's cert folder
ZIP_FILE="$COZYTAK_CERTS_DIR/$USERNAME.zip"
zip -r "$ZIP_FILE" "$USER_CERT_DIR"

# Notify the admin
if [ -e "$ZIP_FILE" ]; then
    echo "Certificate package is ready at: $ZIP_FILE"
else
    echo "Error: Failed to create certificate package."
    exit 1
fi

