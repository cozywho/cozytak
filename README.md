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
- sudo chmod +x /cozytak/*.sh 
- sudo ./start.sh
- y
- 1, reboot
- sudo ./start.sh
- 2, import to firefox
- https://localhost:8443

thanks

FUTURE PLANS:
- organize start.sh to where its a tool you always come back to.
- consolidate part1 & 2.
- cert generation based on user input and packaging them into importable zips.
- multi OS support (Ubuntu & Docker)
- Add existing server upgrade capability to the start menu. If you wanna upgrade just ./upgrade.sh.
- auto add the admin.p12 to the local firefox certs. Idk how to approach this.
- add option during cert-metadata.sh to use default password, or custom password.
- 
