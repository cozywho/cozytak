# gonna add something like i did for wgcg, 

##!/bin/bash
# Check if the script is run as root
#if [ "$(id -u)" -ne 0 ]; then
#    echo "Please run as root"
#   exit 1
#fi
# Move the wgcg script to /usr/local/bin/
#cp wgcg.sh /usr/local/bin/wgcg

# Make the script executable
#chmod +x /usr/local/bin/wgcg

# # Check if ipspace.txt exists and move it to /etc/wireguard/
#if [ -f "ipspace.txt" ]; then
#    cp ipspace.txt /etc/wireguard/ipspace.txt
#else
#    echo "ipspace.txt not found in the repository."
#    exit 1
#fi

# Clean up the installation files
#cd ..
#rm -rf wgcg

#echo "wgcg has been installed successfully. Please modify the /etc/wireguard/ipspace.txt file."
#exit 0
