Single TAK server install for Rocky 8. consists of: 
- start.sh, 
- part1.sh, 
- part2.sh, and 
- takserver.rpm

The install consists of 3 parts
- configuring dependencies for TAK (postgres, java, etc.) 
- installing tak
- configuring tak & certificates

Instructions:
- sudo dnf update -y
- reboot (fully apply updates, kernel, etc.)
- sudo chmod 777 /cozytak/*.sh 
- sudo ./start.sh
- y
- 1, reboot
- sudo ./start.sh
- 2, import to firefox
- https://localhost:8443

thanks

FUTURE PLANS:
- organize start.sh to where its a tool you always come back to.
- Part 1 & 2 for basic install. Maybe hide in a "install takserver" option and put it after the cert generation functionality when added.
- cert generation based on user input and packaging them into importable zips.
- multi OS support.
- Add existing server upgrade capability to the start menu. If you wanna upgrade just ./upgrade.sh.
- auto add the admin.p12 to the local firefox certs.
