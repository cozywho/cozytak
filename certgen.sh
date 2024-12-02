#!/bin/bash

# Certgen.sh script
output_file="certgen_output.txt"

# Prompt user for Localhost IP
read -p "Enter Localhost IP Address: " localhost_ip

# Extract values from CoreConfig.xml
core_config="/opt/tak/CoreConfig.xml"

if [ ! -f "$core_config" ]; then
    echo "Error: $core_config not found."
    exit 1
fi

# Use grep and awk to extract keystorePass, truststorePass, and port
keystorePass=$(grep -oP '(?<=keystorePass=").+?(?=")' "$core_config")
truststorePass=$(grep -oP '(?<=truststorePass=").+?(?=")' "$core_config")
port=$(grep -oP 'auth="x509".*?port="\K\d+' "$core_config")

# Validate extraction
if [[ -z "$keystorePass" || -z "$truststorePass" || -z "$port" ]]; then
    echo "Error: Could not extract all required values from $core_config."
    exit 1
fi

# Write values to output file
{
    echo "Localhost IP Address: $localhost_ip"
    echo "Keystore Password: $keystorePass"
    echo "Truststore Password: $truststorePass"
    echo "Port: $port"
} > "$output_file"

# Confirm to the user
echo "Values have been successfully written to $output_file."

