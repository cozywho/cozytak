# gonna add something like i did for wgcg, 

##!/bin/bash
# Check if the script is run as root
#if [ "$(id -u)" -ne 0 ]; then
#    echo "Please run as root"
#   exit 1
#fi
# Move dependencies to somewhere like /opt/cozytak or something.

#if [ -f "ipspace.txt" ]; then
#    cp ipspace.txt /etc/wireguard/ipspace.txt
#else
#    echo "ipspace.txt not found in the repository."
#    exit 1
#fi

# Move the menu script to /usr/local/bin/ and change script to call on dependencies in opt/tak
#cp menu.sh /usr/local/bin/cozytak

# Make the script executable
#chmod +x /usr/local/bin/cozytak

# Clean up the installation files
#cd ..
#rm -rf wgcg

#echo "wgcg has been installed successfully. Please modify the /etc/wireguard/ipspace.txt file."
#exit 0
