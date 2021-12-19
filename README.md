 /n
 /n
# rasp_influx_grafana
This project enables you to make a influx/grafana server based on a raspberry pi\n
 \n
between <> is content you will need to fill in yourself\n
 \n
### todo: mount on reboot
 \n
## Hardware
- A raspberry Pi\n 
  * I used a 3B+ (but presumably a 4 would work)\n
  * an micro sd card (with a clean raspian image, or a way to flash a new image to the micro-sd)\n
- An external storage device\n
  * I used an 2.5inch samsung ssd, with a ssd to usb connector\n 
 \n
## Preparation (pre req):
- create a clean micro sd card with raspian on it.\n
  * flash a new raspian image to you sd card (i used a linux machine with card reader and https://www.balena.io/etcher/)\n
- enable ssh\n
  * when the micro sd is flashed, but still in the sd card reader -> place an empty file (called "ssh") in the boot drive of the micro sd\n
- have ssh installed on anoter machine (I am using a windows machine)\n
  * for windows open a command terminal and enter ssh\n
  * when you do not get a list of command options for ssh, go to the windows help page \n
  (https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)\n
 \n
## setup raspberry
Insert microsd card in the raspberry,\n 
Make sure the external ssd is connected\n
 \n
I 3D printed a small and simple frame for the ssd and raspberry, you can find the models in:\n
 \n
Note: This code works with an ethernet cable connected\n
### todo? : work with wifi
 \n
### from windows machine connect to ssh
-  log into your router and check what IP the raspberry is running on\n
  * in a windows terminal type ipconfig\n
  * find the default gateway\n
  * open an web browser, go to the adress http://<default gateway adress>\n
  * within the router check what ip the raspberry pi has\n
- in the windwons terminal ssh pi@<rasp_ip>\n
- default password in general is: raspberry\n
 \n
note that it can happen that ssh keys get mismatched\n
this happened to me when I did a clean flash of my micro sd card and hooked up the raspberry again.\n 
great odds it will reuse\n
 \n
you will see a warning stating: "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!"\n
ssh-keygen -R <rasp_ip>\n
 \n
## once you are connected to raspberry pi
### terminal commands to download the sh file
mkdir install_server\n
cd install_server\n
wget https://github.com/spexyphe/rasp_influx_grafana/archive/refs/heads/main.zip\n
unzip main.zip\n
\n
### terminal commands to run the sh file
bash rasp_influx_grafana-main/server_setup.sh\n
 \n
### add external drive to boot
the ssh wil mount the external hd drive \n
but we need to also add it to the boot table  \n
sudo nano /etc/fstab\n
  \n
add the following line \n
/dev/sda1 /media/SSD_Drive ext4 defaults 0 0 \n
 \n
note, my external drive (as chosen in the ssh process, was sda1) \n
note, be carefull, messing this up can cause your system to not be able to boot again \n
 \n
when you need to, or did do a reboot \n
the influx service needs to be restarted with: \n
sudo influxd -config /etc/influxdb/influxdb.conf \n
 \n
 \n
 \n
## open a new terminal
### create a new database and a new user
influx\n
create database home\n
use home\n
create user grafana with password '<passwordhere>' with all privileges\n
grant all privileges on home to grafana\n
show us\n
 \n
### The output should show
user admin\n
---- -----\n
grafana true\n
 \n
 \n
## grafana in web browser
go to a web browser on your windwos machine\n
http://<rasp_ip>:3000\n
 \n
username: admin\n
password: admin\n
 \n
create a new password\n
 \n
## delete config and sh file
