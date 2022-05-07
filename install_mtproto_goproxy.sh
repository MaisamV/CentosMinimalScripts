#!/bin/bash

sudo yum install git -y

#Check go
if ! command -v go &> /dev/null
then
    echo -e "${Yellow}Installing Go${NC}"
    ./install_go18.sh
fi

git clone https://github.com/9seconds/mtg.git
cd mtg
go mod tidy
make static

echo -n "enter the port : "
read PORT
sudo firewall-cmd --zone=public --permanent --add-port=$PORT/tcp
sudo firewall-cmd --zone=public --permanent --add-port=$PORT/udp
sudo firewall-cmd --reload
SECRET=$(./mtg generate-secret --hex google.com)
echo "This is proxy secret: ${SECRET}"
echo "run following command in order to start proxy"
echo "./mtg/mtg simple-run -n 1.1.1.1 -a 51200kib 0.0.0.0:${PORT} ${SECRET}"

cd ..
