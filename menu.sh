#!/bin/bash

# cozytak menu 
echo
echo "Welcome to cozytak. Get comfortable."

# Check if TAK Server is running
takserver_status=$(sudo systemctl is-active takserver 2>/dev/null)
if [[ "$takserver_status" == "active" ]]; then
    takserver_running=true
    echo "TAK Server is currently running."
else
    takserver_running=false
    echo "TAK Server is not running."
fi

# Determine the directory the script is being run from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Your cozytak directory is: $SCRIPT_DIR"
echo "-----------------------------------"
echo "Select an option:"
echo "-----------------------------------"

option_num=1

if [[ "$takserver_running" == false ]]; then
    echo "$option_num. New Install - One Server"
    install_option=$option_num
    ((option_num++))
fi

echo "$option_num. Upgrade existing TAK server"
upgrade_option=$option_num
((option_num++))

echo "$option_num. Certificate Generator (Drag & Drop)"
certgen_option=$option_num
((option_num++))

echo "$option_num. Exit"
exit_option=$option_num

echo "-----------------------------------"
read -p "Enter your choice: " choice

case $choice in
    $install_option)
        if [[ "$takserver_running" == true ]]; then
            echo "Invalid option. New Install is not available because TAK Server is already running."
            exit 1
        fi
        read -p "Are you ready to proceed? (y/n): " ready

        if [[ "${ready,,}" != "y" ]]; then
            echo "Exiting. Ensure you meet all prerequisites before running this script."
            exit 0
        fi

        if [[ -f "$SCRIPT_DIR/singleserver.sh" ]]; then
            source "$SCRIPT_DIR/singleserver.sh"
        else
            echo "Error: singleserver.sh not found in $SCRIPT_DIR."
            exit 1
        fi
        ;;
    $upgrade_option)
        echo "Executing TAK Server Upgrade..."
        if [[ -f "$SCRIPT_DIR/upgrade.sh" ]]; then
            source "$SCRIPT_DIR/upgrade.sh"
        else
            echo "Error: upgrade.sh not found in $SCRIPT_DIR."
            exit 1
        fi
        ;;
    $certgen_option)
        echo "Cert Generation..."
        if [[ -f "$SCRIPT_DIR/certgen.sh" ]]; then
            source "$SCRIPT_DIR/certgen.sh"
        else
            echo "Error: certgen.sh not found in $SCRIPT_DIR."
            exit 1
        fi
        ;;
    $exit_option)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
