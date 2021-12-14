#!/bin/bash
echo "This script will:"
echo "-mount ssd drive"
echo "- install influx"
echo "- install grafana"
echo ""

echo "sh script: mount ssd drive"

# check devices connected
sudo lsblk

#let user choose a device
echo ""
echo "sh script: please select device, type device (e.g. sda1), and then hit enter"

read devicename
echo $devicename

echo ""
echo "sh script: media folder content before mount"
#mount ssd drive
ls /media
sudo mkdir /media/SSD_Drive
sudo mount -t ext4 /dev/$devicename /media/SSD_Drive
echo ""
echo "sh script: media/SSD_DRIVE drive folder after mount"
ls /media/SSD_Drive

echo ""
echo "sh script: verification if this folder is indeed stored on the selected drive"
df /media/SSD_Drive

echo ""
echo "sh script: update apt"

#update apt
sudo apt update

echo ""
echo "sh script: upgrade apt"
sudo apt upgrade -y

#install unzip that we might need
sudo apt install unzip

echo "" 
echo "sh script: install influxdb"

#download influx keys
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -

#show add correct os version of influx to apt  
source /etc/os-release
echo "deb https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

# re-update apt
sudo apt update

# install influx
sudo apt install influxdb

echo ""
echo "sh script: run influx"

# enable influx
sudo systemctl unmask influxdb
sudo systemctl enable influxdb

echo ""
echo "sh script: configure influxdb"

#replace the database locations in the config file
sudo sed -i --expression "s@var/lib/influxdb/@media/SSD_Drive/influxdb/@" /etc/influxdb/influxdb.conf

sudo influxd -config /etc/influxdb/influxdb.conf

#starting influx
sudo systemctl start influxdb

#sleep 5

#temp stop influx
#sudo systemctl stop influxdb


#restart the influxdb service
#sudo service influxdb restart
