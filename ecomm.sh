#!/bin/bash  
sudo apt update -y
sudo apt install nginx -y
rm -r /var/ww/html/*
sudo git clone https://github.com/ravi2krishna/ecomm.git
sudo cp -r /home/ubuntu/ecomm/*  /var/www/html

