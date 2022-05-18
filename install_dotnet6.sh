#!/bin/bash

sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum makecache
sudo yum install dotnet-sdk-6.0 -y
