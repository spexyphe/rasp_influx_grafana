

# rasp_influx_grafana
This project enables you to make a influx/grafana server based on a raspberry pi

between <> is content you will need to fill in yourself

### todo: mount on reboot

## Hardware
- A raspberry Pi 
  * I used a 3B+ (but presumably a 4 would work)
  * an micro sd card (with a clean raspian image, or a way to flash a new image to the micro-sd)
- An external storage device
  * I used an 2.5inch samsung ssd, with a ssd to usb connector 

## Preparation (pre req):
- create a clean micro sd card with raspian on it.
  * flash a new raspian image to you sd card (i used a linux machine with card reader and https://www.balena.io/etcher/)
- enable ssh
  * when the micro sd is flashed, but still in the sd card reader -> place an empty file (called "ssh") in the boot drive of the micro sd
- have ssh installed on anoter machine (I am using a windows machine)
  * for windows open a command terminal and enter ssh
  * when you do not get a list of command options for ssh, go to the windows help page 
  (https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)

## setup raspberry
Insert microsd card in the raspberry, 
Make sure the external ssd is connected

I 3D printed a small and simple frame for the ssd and raspberry, you can find the models in:

Note: This code works with an ethernet cable connected
### todo? : work with wifi

### from windows machine connect to ssh
-  log into your router and check what IP the raspberry is running on
  * in a windows terminal type ipconfig
  * find the default gateway
  * open an web browser, go to the adress http://<default gateway adress>
  * within the router check what ip the raspberry pi has
- in the windwons terminal ssh pi@<rasp_ip>
- default password in general is: raspberry

note that it can happen that ssh keys get mismatched 
this happened to me when I did a clean flash of my micro sd card and hooked up the raspberry again. 
great odds it will reuse

you will see a warning stating: "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!"
ssh-keygen -R <rasp_ip>

## once you are connected to raspberry pi
### terminal commands to download the sh file
mkdir install_server
cd install_server
wget https://github.com/spexyphe/rasp_influx_grafana/archive/refs/heads/main.zip
unzip main.zip

### terminal commands to run the sh file
bash rasp_influx_grafana-main/server_setup.sh

## open a new terminal
### create a new database and a new user
influx
create database home
use home
create user grafana with password '<passwordhere>' with all privileges
grant all privileges on home to grafana
show us

### The output should show
user admin
---- -----
grafana true


## grafana in web browser
go to a web browser on your windwos machine
http://<rasp_ip>:3000

username: admin
password: admin

create a new password

## delete config and sh file
