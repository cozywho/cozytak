# cozytak installation guide

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
- firewall rules
- hide upgrade option is takserver isnt running
- support arguments like `--install`, `--upgrade`, and `--certgen`.
- improve menu organization for repeatable tasks like cert generation. looking at things like whiptail.
- automate certificate packaging into zips for easier import. super important.
- add support for ubuntu and docker.
- automate adding `admin.p12` to local firefox. idk how to approach this.
- allow custom passwords during certificate metadata setup. super important.
