#!/bin/bash

sudo yum install epel-release yum-utils -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum-config-manager --enable remi -y
sudo yum install redis -y

sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf
sed -i 's/^bind 127.0.0.1 -::1/bind * -::*/g' /etc/redis/redis.conf
sudo firewall-cmd --zone=public --permanent --add-port=6379/tcp
sudo firewall-cmd --reload
sudo systemctl restart redis
sudo systemctl enable redis
