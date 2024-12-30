# cozytak installation guide

## installation steps

```bash
sudo dnf update -y
reboot
git clone https://github.com/cozywho/cozytak
cd cozytak/
source install.sh
mv takserver-*.rpm /opt/cozytak/ && rm /opt/cozytak/takserver.rpm

```

import opt/tak/certs/files/admin.p12 into your browser and access the interface at:
```
https://localhost:8443
```

## troubleshooting
if admin certificate authentication fails, run:
```bash
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem
sudo cp /opt/tak/certs/files/admin.p12 whereveryouwant/
sudo chmod 777 admin.p12
```
replace `admin.pem/p12` with the desired admin certificate.
- i cant figure out how to get the java command to succeed in if ran inside of the script. someone plz help.

## future plans
- add a `cozytak` command to simplify launching.
- support arguments like `--install`, `--upgrade`, and `--certgen`.
- improve menu organization for repeatable tasks like cert generation. looking at things like whiptail.
- automate certificate packaging into zips for easier import. super important.
- add support for ubuntu and docker.
- automate adding `admin.p12` to local firefox. idk how to approach this.
- allow custom passwords during certificate metadata setup. super important.
