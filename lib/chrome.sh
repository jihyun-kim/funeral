#bin/sh

if [ "$1" = "ps_off" ]
then
    pkill chromium
    sudo cp -r /etc/lightdm/ps_off.conf /etc/lightdm/lightdm.conf
    sudo service lightdm restart

elif [ "$1" = "ps_on" ]
then
    pkill chromium
    sudo cp -r /etc/lightdm/ps_on.conf /etc/lightdm/lightdm.conf
    sudo service lightdm restart
elif [ "$1" = "restart" ]
then
    pkill chromium
    sudo service lightdm restart
else
    pkill chromium
    export DISPLAY=:0
    /usr/bin/chromium --kiosk --incognito $1
fi
