
CERTS.SH:
modify the /opt/tak/certs/cert-metadata.sh file with default attributes


cd/opt/tak/certs
./makeRootCa.sh
after user follows the prompts from makeRootCa.sh, generate a server cert
./makeCert.sh server takserver
./makeCert.sh client user
./makeCert,sh client admin
#leave tak user
exit

now in existing user, 

sudo systemctl restart takserver
sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem

modify the CoreConfig.xml


