# cozytak installation guide

prereqs:
- fresh Rocky 8 machine
- takserver.rpm from tak.gov on your system

## installation steps for 'cozytak' command

```bash
sudo dnf update -y && sudo dnf install git -y
reboot
git clone https://github.com/cozywho/cozytak
cd cozytak/
source install.sh
mv takserver-*.rpm /opt/cozytak/ && rm /opt/cozytak/takserver.rpm
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
- firewall rules
- support arguments like `--install`, `--upgrade`, and `--certgen`.
- improve menu organization. looking at things like whiptail.
- add support for ubuntu and docker.
- automate adding `admin.p12` to local firefox. idk how to approach this.
