#!/bin/bash

#Prevent network manager from changing DNS
sed -i 's/\[main\]/[main] \
dns=none/g' /etc/NetworkManager/NetworkManager.conf
sudo systemctl restart NetworkManager.service

#Set DNS in network interface config
for NIC in $(ls -l /etc/sysconfig/network-scripts | grep -oG "ifcfg-\w\+" | grep -v ifcfg-lo)
do
	echo "DNS1=178.22.122.100" >> /etc/sysconfig/network-scripts/$NIC
	echo "DNS2=185.51.200.2" >> /etc/sysconfig/network-scripts/$NIC
        echo "Changed DNS of network inteface /etc/sysconfig/network-scripts/$NIC"
done

#Set Shecan DNS in resolv.conf
echo "nameserver 178.22.122.100" > /etc/resolv.conf
echo "nameserver 185.51.200.2" >> /etc/resolv.conf

#Restarting Network do commit changes
systemctl restart network
