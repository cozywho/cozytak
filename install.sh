#!/bin/bash

# Move dependencies to somewhere like /opt/cozytak or something.
chmod +x *.sh
mkdir certs
cd "$(dirname "${BASH_SOURCE[0]}")/.."
sudo mv cozytak /opt/

# Move the menu script to /usr/local/bin/ and change script to call on dependencies in opt/tak
cp /opt/cozytak/menu.sh /usr/local/bin/cozytak

# Make the script executable
chmod +x /usr/local/bin/cozytak

# Clean up the installation files
#cd ..
#rm -rf 

echo "cozytak has been installed successfully."
#exit 0
