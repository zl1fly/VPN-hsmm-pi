#!/bin/bash

clear

cat welcome.msg
read ANSWER

if [ "$ANSWER" != "Y" ]; 
then
    if [ "$ANSWER" != "y" ];
    then
        clear  
        echo "Please e-mail robert (at) kneedrag (dot) org for your info"
        exit 0
    fi
fi

clear
echo "Starting install of VPN packages"
echo
echo
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install vtun
echo 
echo "VPN software has now been installed, next to configure"

clear 
echo "Please enter the Gateway Name (Field A1) : "
read GATEWAY
echo
echo "Please enter your password (Field A2) : "
read PASSWORD
echo 
echo "Please enter VPN client IP (Field A3) : "
read CLIENT_IP
echo
echo "Please enter VPN Server IP (Field A4) : "
read SERVER_IP

cat vtund.conf.template | sed s/_gateway_/$GATEWAY/g | \
    sed s/_password_/$PASSWORD/g | \
    sed s/_client_ip_/$CLIENT_IP/g | \
    sed s/_server_ip_/$SERVER_IP/g > vtund.conf

sudo cp vtund.conf /etc

cat vtun.template | sed s/_gateway_/$GATEWAY/g > vtun

sudo cp vtun /etc/default

sudo /etc/init.d/vtun restart

clear

echo "Adding remote support user"

sudo groupadd mesh-support
sudo useradd -g mesh-support -d /home/mesh-support -m mesh-support
sudo echo mesh-support:-p0o9i8u | sudo chpasswd
sudo usermod -G sudo mesh-support

clear

echo "Please let ZL1FLY know that this script has now run to confirm your VPN status"
