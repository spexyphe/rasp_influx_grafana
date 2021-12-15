# rasp_influx_grafana
This project enables you to make a influx/grafana server based on a raspberry pi

## Hardware
- A raspberry Pi 
  * I used a 3B+ (but presumably a 4 would work)
  * an micro sd card (with a clean raspian image, or a way to flash a new image to the micro-sd)
- An external storage device
  * I used an 2.5inch samsung ssd, with a ssd to usb connector 

## Preparation:
- create a clean micro sd card with raspian on it.
  * flash a new raspian image to you sd card (i used a linux machine with card reader and https://www.balena.io/etcher/)
- enable ssh
  * when the micro sd is flashed, but still in the sd card reader -> place an empty file (called "ssh") in the boot drive of the micro sd

## setup raspberry
Insert microsd card in the raspberry, 
Make sure the external ssd is connected

I 3D printed a small and simple frame for the ssd and raspberry, you can find the models in:

Note: This code works with an ethernet cable connected
### todo? : work with wifi

download the sh file


run the sh file

delete config and sh file
