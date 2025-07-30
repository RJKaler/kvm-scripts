#!/bin/bash -e 

updateproc() {
    sudo apt-get update -y &&
        sudo apt-get upgrade -y
    }

echo "updating first..."
updateproc

if sudo apt install spice-vdagent qemu-guest-agent; then
    echo "necessary packages installed - restating daemon..."
else
    echo "failed to install necessary packages"
    exit 1
fi

if sudo systemctl start --now spice-vdagent; then
    echo "successfully restarted daemon"
else
    echo "failed to restart daemon"
    exit 1
fi

read -rp "A reboot is required for spice to take effect.
Reboot now? yes or no: " ans

if [[ "$ans" == "yes" ]]; then
    sudo shutdown -r now
else
    echo "OK - exiting script"
fi

exit 0

