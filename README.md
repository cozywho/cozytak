Single TAK server install for Rocky 8. consists of: 
- start.sh, 
- part1.sh, 
- part2.sh, and 
- takserver.rpm

sudo ./start.sh

The install consists of 3 parts
- configuring dependencies for TAK (postgres, java, etc.) 
- installing tak
- configuring tak & certificates

Best practice is probably:
- sudo dnf update -y
- reboot (fully apply updates, kernel, etc.)
- sudo chmod 777 /cozytak/*.sh 
-

thanks
