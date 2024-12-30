# CozyTAK Installation Guide

## Installation Steps

### Update and Reboot System
```bash
sudo dnf update -y
reboot
```
> Fully apply updates, including kernel updates.

### Clone the Repository
```bash
git clone https://github.com/cozywho/cozytak
```

### Prepare TAKServer RPM
```bash
mv takserver-*.rpm cozytak/ && rm cozytak/takserver.rpm
```
> Replace the placeholder `takserver.rpm` in `cozytak/` with the real one.

### Navigate to CozyTAK Directory
```bash
cd cozytak/
```

### Set Script Permissions
```bash
sudo chmod +x *.sh
```

### Source the Menu Script
```bash
source menu.sh
```

### Install Accordingly
Follow the menu options to complete the installation.

### Import Certificates to Browser
Access the admin interface at:
```
https://localhost:8443
```

### Troubleshooting
Sometimes, Java throws an error, and the admin certificate authentication fails. If this happens, run the following command:

```bash
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem
```
Replace `admin.pem` with the certificate you want to give admin rights to.

## Future Plans
- Create a `cozytak` command to launch the menu directly.
- Add arguments for commands like `install`, `upgrade`, and `certgen` (e.g., `cozytak --install`).
- Improve menu organization, especially for making certificate generation repeatable.
- Enable user-input-based certificate generation and package certificates into importable zips.
- Add support for multi-OS environments (e.g., Ubuntu and Docker).
- Automate the addition of `admin.p12` to local Firefox certificates.
- Provide an option during `cert-metadata.sh` to use a default or custom password.

---
