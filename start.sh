#!/bin/bash

# TAK Single Server Install Script - Start

# Determine the directory the script is being run from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script directory: $SCRIPT_DIR"

# Confirm prerequisites
echo "TAK Single Server Install"
echo "Ensure you meet the following prerequisites:"
echo "1. Logged in as your created admin user."
echo "2. Working internet connection (offline install not supported)."
echo "3. Run 'sudo dnf update -y' and reboot if there are kernel updates."
echo "4. The following files are in $SCRIPT_DIR:"
echo "   - part1.sh"
echo "   - part2.sh"
echo "   - takserver.rpm"
echo
read -p "Are you ready to proceed? (y/n): " ready

if [[ "${ready,,}" != "y" ]]; then
    echo "Exiting. Ensure you meet all prerequisites before running this script."
    exit 0
fi

# Provide options for Part 1 or Part 2
echo
echo "Select an option:"
echo "1. Part 1: New Install - One Server"
echo "2. Part 2: Certificates (Appendix B)"
echo "3. Exit"
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        echo "Executing Part 1: New Install - One Server..."
        if [[ -f "$SCRIPT_DIR/part1.sh" ]]; then
            bash "$SCRIPT_DIR/part1.sh"
        else
            echo "Error: part1.sh not found in $SCRIPT_DIR."
            exit 1
        fi
        ;;
    2)
        echo "Executing Part 2: Certificates (Appendix B)..."
        if [[ -f "$SCRIPT_DIR/part2.sh" ]]; then
            bash "$SCRIPT_DIR/part2.sh"
        else
            echo "Error: part2.sh not found in $SCRIPT_DIR."
            exit 1
        fi
        ;;
    3)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
