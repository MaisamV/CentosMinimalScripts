#!/bin/bash

#Set DNS in network interface config
for NIC in $(ls -l /etc/sysconfig/network-scripts | grep -oG "ifcfg-\w\+" | grep -v ifcfg-lo)
do
	sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/$NIC
	echo "Enabled /etc/sysconfig/network-scripts/$NIC"
done

systemctl restart network
