#!/bin/bash

GATEWAY=$1
PASSWORD=$2
CLIENT_IP=$3
SERVER_IP=$4
SUPPORT_PASSWORD=$5

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

cat vtund.conf.template | sed s/_gateway_/$GATEWAY/g | \
    sed s/_password_/$PASSWORD/g | \
    sed s/_client_ip_/$CLIENT_IP/g | \
    sed s/_server_ip_/$SERVER_IP/g > vtund.conf

sudo cp vtund.conf /etc

cat vtun.template | sed s/_gateway_/$GATEWAY/g > vtun

sudo cp vtun /etc/default

echo "Starting VPN"

sudo /etc/init.d/vtun restart


echo "Adding remote support user"
echo "Do you want to add login support for ZL1FLY (Y/N)"
read ANSWER


if [ "$ANSWER" != "N" ]; 
then
    if [ "$ANSWER" != "n" ];
    then
        sudo groupadd mesh-support
        sudo useradd -g mesh-support -d /home/mesh-support -m mesh-support
        sudo echo mesh-support:$SUPPORT_PASSWORD | sudo chpasswd
        sudo usermod -G sudo mesh-support
    fi
fi

clear
echo "Please let ZL1FLY know that this script has now run to confirm your VPN status"

echo "Rebooting to finalize VPN device."

sudo init 6