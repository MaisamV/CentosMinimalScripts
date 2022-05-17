#!/bin/bash

sudo yum install bind bind-utils -y
sed -i 's/listen-on\s\+port\s\+53\s\+{\s\+127.0.0.1;\s\+};/listen-on port 53 { 127.0.0.1; any; };\n\tallow-query-cache { localhost; any; };/g' /etc/named.conf
sed -i 's/allow-query\s\+{\s\+localhost;\s\+};/allow-query { localhost; any; };\n/g' /etc/named.conf
sed -i 's/recursion no;/recursion yes;/g' /etc/named.conf
sudo chown root:named /etc/named.conf
sudo chcon system_u:object_r:etc_t:s0 /etc/named.conf
systemctl enable named
systemctl restart named
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --reload
