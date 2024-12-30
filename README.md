# CozyTAK Installation Guide

## Installation Steps

### 1. Update and Reboot
```bash
sudo dnf update -y
reboot
```

### 2. Clone the Repository
```bash
git clone https://github.com/cozywho/cozytak
```

### 3. Prepare TAKServer RPM
```bash
mv takserver-*.rpm cozytak/ && rm cozytak/takserver.rpm
```
> Replace `takserver.rpm` with the actual file.

### 4. Navigate to CozyTAK Directory
```bash
cd cozytak/
```

### 5. Set Script Permissions
```bash
sudo chmod +x *.sh
```

### 6. Run the Menu Script
```bash
source menu.sh
```
Follow the menu options to complete the installation.

### 7. Import Certificates
Import certificates into your browser and access the interface at:
```
https://localhost:8443
```

### Troubleshooting
If admin certificate authentication fails, run:
```bash
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem
```
Replace `admin.pem` with the desired admin certificate.

## Future Plans
- Add a `cozytak` command to simplify launching.
- Support arguments like `--install`, `--upgrade`, and `--certgen`.
- Improve menu organization for repeatable tasks like cert generation.
- Automate certificate packaging into zips for easier import.
- Add support for Ubuntu and Docker.
- Automate adding `admin.p12` to local Firefox.
- Allow custom passwords during certificate metadata setup.
