#!/bin/bash
Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
   exit 1
fi

# Move dependencies to somewhere like /opt/cozytak or something.
chmod +x *.sh
sudo mkdir opt/cozytak
sudo mv !(install).sh /opt/cozytak

# Move the menu script to /usr/local/bin/ and change script to call on dependencies in opt/tak
cp menu.sh /usr/local/bin/cozytak

# Make the script executable
chmod +x /usr/local/bin/cozytak

# Clean up the installation files
#cd ..
#rm -rf 

echo "cozytak has been installed successfully."
#exit 0
