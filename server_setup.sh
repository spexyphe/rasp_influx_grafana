#!/bin/bash
echo "This script will:"
echo "Change rasp password "
echo "-mount ssd drive"
echo "- install influx"
echo "- install grafana"

echo ""
echo "sh script: for safety purposes we first want to change the password"
passwd


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

#install unzip that we might need
sudo apt install unzip

echo ""
echo "sh script: upgrade apt"
sudo apt upgrade -y

echo ""
echo "sh script: create correct links for apt to influx and grafana"

#download influx keys
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -

#show add correct os version of influx to apt  
source /etc/os-release
echo "deb https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

#add correct version of grafana
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# re-update apt
sudo apt update

echo "" 
echo "sh script: install influxdb"

# install influx
sudo apt install influxdb

echo "" 
echo "sh script: install grafana"

# install grafana
sudo apt update && sudo apt install -y grafana

echo ""
echo "sh script: run grafana"

# run grafana
sudo systemctl unmask grafana-server.service
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service

echo ""
echo "sh script: run influx"

# enable influx
sudo systemctl unmask influxdb.service
sudo systemctl start influxdb
sudo systemctl enable influxdb.service

echo ""
echo "sh script: configure influxdb"

# wait 10 seconds to settle down
sleep 10

# temp stop influx
sudo systemctl stop influxdb

# replace the database locations in the config file
sudo sed -i --expression "s@var/lib/influxdb/@media/SSD_Drive/influxdb/@" /etc/influxdb/influxdb.conf

#give influx acces to things it need to start
sudo chmod +x /usr/lib/influxdb/scripts/influxd-systemd-start.sh 
sudo chown -R influxdb:influxdb /media/SSD_Drive/influxdb/*

# let influx load the config
# sudo influxd -config /etc/influxdb/influxdb.conf

#restart the influxdb service
sudo systemctl start influxdb
