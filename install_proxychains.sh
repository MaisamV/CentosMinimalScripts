#!/bin/bash

sudo yum install git -y
sudo yum groupinstall "Development Tools" -y
git clone https://github.com/rofl0r/proxychains-ng.git
cd proxychains-ng
./configure
make && make install
./tools/install.sh -D -m 644 libproxychains4.so /usr/local/lib/libproxychains4.so
./tools/install.sh -D -m 644 src/proxychains.conf /usr/local/etc/proxychains.conf

echo -n Enter protocol(http/https/socks4):
read protocol
echo

echo -n Enter domain:
read domain
echo

echo -n Enter port:
read port
echo

echo -n Enter proxy username:
read username
echo

echo -n Enter proxy password:
read -s password
echo

sed -i "s/socks4\s\+127.0.0.1\s\+9050/$protocol\t$domain\t$port\t$username\t$password/g" /usr/local/etc/proxychains.conf
cd ..
