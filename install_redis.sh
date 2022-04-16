#!/bin/bash

sudo yum install epel-release yum-utils -y
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum-config-manager --enable remi -y
sudo yum install redis -y

sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf
sudo systemctl start redis
sudo systemctl enable redis
