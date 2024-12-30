#!/bin/bash

# cozytak menu 
echo
echo "Welcome to cozytak. Get comfortable."
# Determine the directory the script is being run from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Your cozytak directory is: $SCRIPT_DIR"
echo "-----------------------------------"
echo "Select an option:"
echo "-----------------------------------"
echo "1. New Install - One Server"
echo "2. Upgrade existing TAK server"
echo "-----------------------------------"
echo "3. Certificate Generator (Drag & Drop)"
echo "-----------------------------------"
echo "4. Exit"
echo "-----------------------------------"
read -p "Enter your choice (1/2/3/4): " choice

case $choice in
    1)
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
    2)
        echo "Executing TAK Server Upgrade..."
        if [[ -f "$SCRIPT_DIR/upgrade.sh" ]]; then
            source "$SCRIPT_DIR/upgrade.sh"
        else
            echo "Error: upgrade.sh not found in $SCRIPT_DIR."
            exit 1
        fi
        ;;
    3)
        echo "Cert Generation..."
        if [[ -f "$SCRIPT_DIR/certgen.sh" ]]; then
            source "$SCRIPT_DIR/certgen.sh"
        else
            echo "Error: certgen.sh not found in $SCRIPT_DIR."
            exit 1
        fi
        ;;
    4)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
