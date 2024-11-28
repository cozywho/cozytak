TAK Single Server Install

Notice: 
Ensure you are logged in as your created admin user.
Ensure you have a working internet connection. Offline install currently not supported.
Ensure ~/cozytak exists.
Run 'sudo dnf update -y' before you execute this script. Reboot if there's kernel updates.

This is intended to be used on a fresh (updated) Rocky 8 install, although it could work on 9. Confirm you are ready.
(y/n)

if y, start
if n, quit



Base Install:
#Verify contents of this folder: ~/cozytak should contain 3 files. "install.sh, certs.sh & takserver-x.x-RELEASE...."
#Configuring multiple TCP connections
echo -e "* soft nofile 32768" | sudo tee --append /etc/security/limits.conf > /dev/null
echo -e "* hard nofile 32768" | sudo tee --append /etc/security/limits.conf > /dev/null
#install epel
sudo dnf install epel-release -y
#adding postgres repo and installing java
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -qy module disable PostgreSQL
#Updating system
sudo dnf update -y
#Install Java
sudo dnf install java-17-openjdk-devel -y
sudo dnf config-manager --set-enabled powertools
sudo dnf install takserver-5.1-RELEASEx.noarch.rpm -y
sudo dnf install checkpolicy
cd /opt/tak && sudo ./apply-selinux.sh && sudo semodule -l | grep takserver


sudo systemctl daemon-reload
sudo systemctl start takserver
sudo systemctl enable takserver

#Place the certs.sh file in /home/tak, swith users, then run the file
cp certs.sh /home/tak
sudo su tak
./certs.sh

