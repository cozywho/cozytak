sudo java -jar /opt/tak/utils/UserManager.jar certmod -A /opt/tak/certs/files/admin.pem
# Store script directory value
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy admin cert to cozytak folder for user to import.
# sudo cp /opt/tak/certs/files/admin.pem "$SCRIPT_DIR/admin.pem" && sudo chown $(whoami):$(whoami) "$SCRIPT_DIR/admin.pem"
sudo cp /opt/tak/certs/files/admin.p12 "$SCRIPT_DIR/admin.p12" && sudo chmod 777 "$SCRIPT_DIR/admin.p12" 
