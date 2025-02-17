# cozytak installation guide

prereqs:
- fresh Rocky 8 or Ubuntu machine
- takserver.rpm or takserver.deb from tak.gov on your system

## installation steps for 'cozytak' utility: Rocky 8

```bash
sudo dnf update -y && sudo dnf install git -y
reboot
git clone https://github.com/cozywho/cozytak
cd cozytak/
source install.sh
mv takserver-*.rpm /opt/cozytak/ && rm /opt/cozytak/takserver.rpm
cozytak
```

## installation steps for 'cozytak' utility: Ubuntu

```bash
sudo apt update -y && sudo apt upgrade -y
reboot
git clone https://github.com/cozywho/cozytak
cd cozytak/
source install.sh
mv takserver_*.deb /opt/cozytak/ && rm /opt/cozytak/takserver.rpm
cozytak
```

Once 'cozytak' is installed you are ready to install tak server, upgrade existing tak servers, and generate user certificates.

import opt/tak/certs/files/admin.p12 into your browser and access the interface at:
```
https://localhost:8443
```
- ps you will need to change file permissions unless youre remoted in and winSCPing or something.
- also remember firewall rules.

## user cert generation
- creates a drap & droppable .zip package for ATAK & WinTAK clients.
- zips located in /opt/cozytak/certs

## future plans
- allow custom passwords during certificate metadata setup. super important.
    - Ask for password input before the atakatak step, confirm password, if mismatch: "PASSWORD DIDNT MATCH", if match, continue.
- firewall rules
    - Maybe a reminder of common rules? Or the default 8443 or something.
- support arguments like `--install`, `--upgrade`, and `--certgen`. Idk if this matters when the menu is a thing.
- improve menu organization. looking at things like whiptail.
- add support for docker install, allowing 3 options.
- automate adding `admin.p12` to local firefox. idk how to approach this or if its really necessary.
    - Seems like too many issues can happen with this based on environment, considering standalone minimal tak server and desktop environemt are 2 valid options. Eh.
