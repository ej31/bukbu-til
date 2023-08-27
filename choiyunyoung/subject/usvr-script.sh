#!/bin/bash

echo "PASSWORD" | sudo -kS apt-get update
sudo apt-get install libncurses5 apache2 apache2-utils -y
sleep 15
cd /var/www/html
wget https://kr.object.ncloudstorage.com/ncp manual/ncp/ncp lab.tgz
sleep 10
tar xvfz ncp-lab.tgz
cat phpadd >> /etc/httpd/conf/httpd.conf
sudo apt-get install gnupg curl
sleep 10

curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /etc/apt/trusted.gpg.d/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sleep 10

sudo apt install php php-redis php-mysql mysql-client mariadb-server mariadb-client mongodb-org php-mongodb -y
sleep 60
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sleep 30
sudo apt-get install -y nodejs
sleep 10

sudo systemctl enable apache2
sudo systemctl enable mariadb
sudo systemctl enable mongod

sudo systemctl start apache2
sudo systemctl start mariadb
sudo systemctl start mongod

mysql < dbstep1.sql
mysql < dbstep2.sql