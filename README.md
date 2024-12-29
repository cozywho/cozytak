git clone https://github.com/cozywho/cozytak

run this command:
``

replace the placeholder takserver.rpm in cozytak/ with the real one.

- sudo dnf update -y
- reboot (fully apply updates, kernel, etc.)
- sudo chmod +x /cozytak/*.sh 
- sudo menu.sh
- install accordingly
- import certs to browser
- https://localhost:8443

thanks

FUTURE PLANS:
- make cozytak a command, taking you to the menu.
- add arguments for install, upgrade, certgen. ex: cozytak --install (idk about this)
- organize the menu better, indending for certgen to be a repeatable tool.
- cert generation based on user input and packaging them into importable zips.
- multi OS support (Ubuntu & Docker)
- auto add the admin.p12 to the local firefox certs. Idk how to approach this.
- add option during cert-metadata.sh to use default password, or custom password.
