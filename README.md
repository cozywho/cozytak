# cozytak installation guide

## installation steps

```bash
sudo dnf update -y
reboot
git clone https://github.com/cozywho/cozytak
mv takserver-*.rpm cozytak/ && rm cozytak/takserver.rpm
chmod +x cozytak/*.sh && cd cozytak
source menu.sh
```

import opt/tak/certs/files/admin.p12 into your browser and access the interface at:
```
https://localhost:8443
```

## troubleshooting
if admin certificate authentication fails, run:
```bash
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem
```
replace `admin.pem` with the desired admin certificate.
- i cant figure out how to get this to succeed in if ran inside of the script. someone plz help.

## future plans
- add a `cozytak` command to simplify launching.
- support arguments like `--install`, `--upgrade`, and `--certgen`.
- improve menu organization for repeatable tasks like cert generation.
- automate certificate packaging into zips for easier import.
- add support for ubuntu and docker.
- automate adding `admin.p12` to local firefox.
- allow custom passwords during certificate metadata setup.
