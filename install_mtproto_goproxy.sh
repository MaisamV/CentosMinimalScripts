#!/bin/bash

sudo yum install git -y

#Check go
if ! command -v go &> /dev/null
then
    echo -e "${Yellow}Installing Go${NC}"
    ./install_go18.sh
fi

CUD=$(pwd)

git clone https://github.com/9seconds/mtg.git
mv ./mtg /root
cd /root/mtg
go mod tidy
make static

echo -n "enter the port : "
read PORT
sudo firewall-cmd --zone=public --permanent --add-port=$PORT/tcp
sudo firewall-cmd --zone=public --permanent --add-port=$PORT/udp
sudo firewall-cmd --reload

SECRET=$(./mtg generate-secret --hex google.com)

echo "#!/bin/bash" > mtg_start.sh
echo "PORT=${PORT}" >> mtg_start.sh
echo "SECRET=${SECRET}" >> mtg_start.sh
echo "/root/mtg/mtg simple-run -n 1.1.1.1 -a 51200kib 0.0.0.0:${PORT} ${SECRET} > /dev/null 2>&1" >> mtg_start.sh
chmod u+x mtg_start.sh

echo "[Unit]" > /etc/systemd/system/mtg.service
echo "Description = MTproto proxy service" >> /etc/systemd/system/mtg.service
echo "After = network.target" >> /etc/systemd/system/mtg.service
echo "" >> /etc/systemd/system/mtg.service
echo "[Service]" >> /etc/systemd/system/mtg.service
echo "ExecStart = /root/mtg/mtg_start.sh" >> /etc/systemd/system/mtg.service
echo "" >> /etc/systemd/system/mtg.service
echo "[Install]" >> /etc/systemd/system/mtg.service
echo "WantedBy = multi-user.target" >> /etc/systemd/system/mtg.service

sudo systemctl enable mtg.service
sudo systemctl start mtg.service

cd $CUD

echo "This is proxy secret: ${SECRET}"
IP=$(curl -sSL ifconfig.me)
echo "https://t.me/proxy?server=${IP}&port=${PORT}&secret=${SECRET}"
