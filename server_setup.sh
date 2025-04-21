#!/bin/bash
echo "This script will:"
echo "Change rasp password "
echo "-mount ssd drive"
echo "- install influx"
echo "- install grafana"

echo ""
echo "sh script: for safety purposes we first want to change the password"
read -p "Change password (y/n)?" choice
case "$choice" in 
  y|Y ) passwd;;
  n|N ) echo "password has not been updated";;
  * ) passwd;;
esac

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

read -p "Do you want to format the media (y/n)?" choice_disk
case "$choice_disk" in 
  y|Y ) fdisk /media/SSD_Drive;;
  n|N ) echo "skipped formatting";;
  * ) echo "skipped formatting";;
esac

echo ""
echo "sh script: update apt"

#update apt
sudo apt update

#install unzip that we might need
sudo apt install unzip

# these packages are needed for grafana
sudo apt-get install -y apt-transport-https software-properties-common wget

echo ""
echo "sh script: upgrade apt"
sudo apt upgrade -y

echo ""
echo "sh script: create correct links for apt to influx and grafana"

sudo mkdir -p /etc/apt/keyrings/

#download influx and grafana keys
wget -q -O - https://repos.influxdata.com/influxdata-archive.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg > /dev/null 
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null 

echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' | sudo tee -a /etc/apt/sources.list.d/influxdata.list
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# re-update apt
sudo apt update

# wait 10 seconds to settle down
sleep 10

echo "" 
echo "sh script: install influxdb"

# install influx
sudo apt-get install -y influxdb2

echo "" 
echo "sh script: install grafana"

# install grafana
sudo apt update && sudo apt-get install -y grafana

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
