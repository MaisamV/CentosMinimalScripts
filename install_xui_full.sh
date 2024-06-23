#!/bin/bash

update_server() {
  apt update && apt upgrade -y
}

install_dependencies() {
  apt install curl socat ufw curl git -y
  curl https://get.acme.sh | sh
}

install_panel() {
  printf 'n\n' | bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
  /usr/local/x-ui/x-ui setting -username admin -password admin
  /usr/local/x-ui/x-ui setting -webBasePath /
  /usr/local/x-ui/x-ui setting -port $1
  /usr/local/x-ui/x-ui cert -reset
  printf '11\n\n0\n' | x-ui > /dev/null
}

add_inbounds() {
  username=$(printf '8\n' | x-ui | grep -Po 'username: \K[^\n\s]*')
  password=$(printf '8\n' | x-ui | grep -Po 'password: \K[^\n]*')
  port=$(printf '8\n' | x-ui | grep -Po 'port: \K[^\n\s]*')
  path=$(printf '8\n' | x-ui | grep -Po 'webBasePath: \K[^\n\s]*')
  ipv6=$(curl -s -6 https://ifconfig.co)
  session=$(curl -Lv "http://127.0.0.1:${port}${path}login" -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Connection: keep-alive' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Cookie: lang=en-US' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' --data-raw "username=${username}&password=${password}" --insecure 2>&1 | grep -Po 'session=\K[^;]*')

  curl -L "http://127.0.0.1:${port}${path}panel/inbound/add" -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Connection: keep-alive' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Cookie: lang=en-US; session="'${session}'"' --data-raw 'up=0&down=0&total=0&remark=vless6-tcp&enable=true&expiryTime=0&listen=&port='$1'&protocol=vless&settings=%7B%0A%20%20%22clients%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22id%22%3A%20%22f7dbfe29-c0a8-43f1-8663-1de698ae1607%22%2C%0A%20%20%20%20%20%20%22flow%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22email%22%3A%20%22ot0wk8vz%22%2C%0A%20%20%20%20%20%20%22limitIp%22%3A%200%2C%0A%20%20%20%20%20%20%22totalGB%22%3A%200%2C%0A%20%20%20%20%20%20%22expiryTime%22%3A%200%2C%0A%20%20%20%20%20%20%22enable%22%3A%20true%2C%0A%20%20%20%20%20%20%22tgId%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22subId%22%3A%20%227vthn971ebeftnaj%22%2C%0A%20%20%20%20%20%20%22reset%22%3A%200%0A%20%20%20%20%7D%0A%20%20%5D%2C%0A%20%20%22decryption%22%3A%20%22none%22%2C%0A%20%20%22fallbacks%22%3A%20%5B%5D%0A%7D&streamSettings=%7B%0A%20%20%22network%22%3A%20%22tcp%22%2C%0A%20%20%22security%22%3A%20%22none%22%2C%0A%20%20%22externalProxy%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22forceTls%22%3A%20%22same%22%2C%0A%20%20%20%20%20%20%22dest%22%3A%20%22%5B'${ipv6}'%5D%22%2C%0A%20%20%20%20%20%20%22port%22%3A%20'$1'%2C%0A%20%20%20%20%20%20%22remark%22%3A%20%22%22%0A%20%20%20%20%7D%0A%20%20%5D%2C%0A%20%20%22tcpSettings%22%3A%20%7B%0A%20%20%20%20%22acceptProxyProtocol%22%3A%20false%2C%0A%20%20%20%20%22header%22%3A%20%7B%0A%20%20%20%20%20%20%22type%22%3A%20%22http%22%2C%0A%20%20%20%20%20%20%22request%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%22version%22%3A%20%221.1%22%2C%0A%20%20%20%20%20%20%20%20%22method%22%3A%20%22GET%22%2C%0A%20%20%20%20%20%20%20%20%22path%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%20%20%22%2F%22%0A%20%20%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%20%20%22headers%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22Host%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22fast.com%22%0A%20%20%20%20%20%20%20%20%20%20%5D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%22response%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%22version%22%3A%20%221.1%22%2C%0A%20%20%20%20%20%20%20%20%22status%22%3A%20%22200%22%2C%0A%20%20%20%20%20%20%20%20%22reason%22%3A%20%22OK%22%2C%0A%20%20%20%20%20%20%20%20%22headers%22%3A%20%7B%7D%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D&sniffing=%7B%0A%20%20%22enabled%22%3A%20true%2C%0A%20%20%22destOverride%22%3A%20%5B%0A%20%20%20%20%22http%22%2C%0A%20%20%20%20%22tls%22%2C%0A%20%20%20%20%22quic%22%2C%0A%20%20%20%20%22fakedns%22%0A%20%20%5D%2C%0A%20%20%22metadataOnly%22%3A%20false%2C%0A%20%20%22routeOnly%22%3A%20false%0A%7D' --insecure
  curl -L "http://127.0.0.1:${port}${path}panel/inbound/add" -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Connection: keep-alive' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Cookie: lang=en-US; session="'${session}'"' --data-raw 'up=0&down=0&total=0&remark=vless-grpc-reality&enable=true&expiryTime=0&listen=&port='$2'&protocol=vless&settings=%7B%0A%20%20%22clients%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22id%22%3A%20%221702ef38-3d4f-485d-97b9-ac9ff9a48073%22%2C%0A%20%20%20%20%20%20%22flow%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22email%22%3A%20%22kc44ovtw%22%2C%0A%20%20%20%20%20%20%22limitIp%22%3A%200%2C%0A%20%20%20%20%20%20%22totalGB%22%3A%200%2C%0A%20%20%20%20%20%20%22expiryTime%22%3A%200%2C%0A%20%20%20%20%20%20%22enable%22%3A%20true%2C%0A%20%20%20%20%20%20%22tgId%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22subId%22%3A%20%22r87skn91z95a96me%22%2C%0A%20%20%20%20%20%20%22reset%22%3A%200%0A%20%20%20%20%7D%0A%20%20%5D%2C%0A%20%20%22decryption%22%3A%20%22none%22%2C%0A%20%20%22fallbacks%22%3A%20%5B%5D%0A%7D&streamSettings=%7B%0A%20%20%22network%22%3A%20%22grpc%22%2C%0A%20%20%22security%22%3A%20%22reality%22%2C%0A%20%20%22externalProxy%22%3A%20%5B%5D%2C%0A%20%20%22realitySettings%22%3A%20%7B%0A%20%20%20%20%22show%22%3A%20false%2C%0A%20%20%20%20%22xver%22%3A%200%2C%0A%20%20%20%20%22dest%22%3A%20%22zula.ir%3A443%22%2C%0A%20%20%20%20%22serverNames%22%3A%20%5B%0A%20%20%20%20%20%20%22zula.ir%22%0A%20%20%20%20%5D%2C%0A%20%20%20%20%22privateKey%22%3A%20%22WOg76qufsCh3pWZ9NZVs_jgn5aBMQYImzQRq1lDWKhE%22%2C%0A%20%20%20%20%22minClient%22%3A%20%22%22%2C%0A%20%20%20%20%22maxClient%22%3A%20%22%22%2C%0A%20%20%20%20%22maxTimediff%22%3A%200%2C%0A%20%20%20%20%22shortIds%22%3A%20%5B%0A%20%20%20%20%20%20%22f95769d5%22%0A%20%20%20%20%5D%2C%0A%20%20%20%20%22settings%22%3A%20%7B%0A%20%20%20%20%20%20%22publicKey%22%3A%20%22v9PHyM-QMe3jpphmQUN2td41Tj85387-FhU3wfpaCxY%22%2C%0A%20%20%20%20%20%20%22fingerprint%22%3A%20%22randomized%22%2C%0A%20%20%20%20%20%20%22serverName%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22spiderX%22%3A%20%22%2F%22%0A%20%20%20%20%7D%0A%20%20%7D%2C%0A%20%20%22grpcSettings%22%3A%20%7B%0A%20%20%20%20%22serviceName%22%3A%20%22Product%22%2C%0A%20%20%20%20%22authority%22%3A%20%22%22%2C%0A%20%20%20%20%22multiMode%22%3A%20false%0A%20%20%7D%0A%7D&sniffing=%7B%0A%20%20%22enabled%22%3A%20true%2C%0A%20%20%22destOverride%22%3A%20%5B%0A%20%20%20%20%22http%22%2C%0A%20%20%20%20%22tls%22%2C%0A%20%20%20%20%22quic%22%2C%0A%20%20%20%20%22fakedns%22%0A%20%20%5D%2C%0A%20%20%22metadataOnly%22%3A%20false%2C%0A%20%20%22routeOnly%22%3A%20false%0A%7D' --insecure
  curl -L "http://127.0.0.1:${port}${path}panel/inbound/add" -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Connection: keep-alive' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Cookie: lang=en-US; session="'${session}'"' --data-raw 'up=0&down=0&total=0&remark=vless-tcp&enable=true&expiryTime=0&listen=&port='$3'&protocol=vless&settings=%7B%0A%20%20%22clients%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22id%22%3A%20%227fa06a85-0892-4e28-af22-547ec72aeae5%22%2C%0A%20%20%20%20%20%20%22flow%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22email%22%3A%20%22pk5w20w9%22%2C%0A%20%20%20%20%20%20%22limitIp%22%3A%200%2C%0A%20%20%20%20%20%20%22totalGB%22%3A%200%2C%0A%20%20%20%20%20%20%22expiryTime%22%3A%200%2C%0A%20%20%20%20%20%20%22enable%22%3A%20true%2C%0A%20%20%20%20%20%20%22tgId%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22subId%22%3A%20%22hplcleh1nn6nsa7g%22%2C%0A%20%20%20%20%20%20%22reset%22%3A%200%0A%20%20%20%20%7D%0A%20%20%5D%2C%0A%20%20%22decryption%22%3A%20%22none%22%2C%0A%20%20%22fallbacks%22%3A%20%5B%5D%0A%7D&streamSettings=%7B%0A%20%20%22network%22%3A%20%22tcp%22%2C%0A%20%20%22security%22%3A%20%22none%22%2C%0A%20%20%22externalProxy%22%3A%20%5B%5D%2C%0A%20%20%22tcpSettings%22%3A%20%7B%0A%20%20%20%20%22acceptProxyProtocol%22%3A%20false%2C%0A%20%20%20%20%22header%22%3A%20%7B%0A%20%20%20%20%20%20%22type%22%3A%20%22http%22%2C%0A%20%20%20%20%20%20%22request%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%22version%22%3A%20%221.1%22%2C%0A%20%20%20%20%20%20%20%20%22method%22%3A%20%22GET%22%2C%0A%20%20%20%20%20%20%20%20%22path%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%20%20%22%2F%22%0A%20%20%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%20%20%22headers%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22Host%22%3A%20%5B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22www.uptvs.com%22%0A%20%20%20%20%20%20%20%20%20%20%5D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%22response%22%3A%20%7B%0A%20%20%20%20%20%20%20%20%22version%22%3A%20%221.1%22%2C%0A%20%20%20%20%20%20%20%20%22status%22%3A%20%22200%22%2C%0A%20%20%20%20%20%20%20%20%22reason%22%3A%20%22OK%22%2C%0A%20%20%20%20%20%20%20%20%22headers%22%3A%20%7B%7D%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D&sniffing=%7B%0A%20%20%22enabled%22%3A%20true%2C%0A%20%20%22destOverride%22%3A%20%5B%0A%20%20%20%20%22http%22%2C%0A%20%20%20%20%22tls%22%2C%0A%20%20%20%20%22quic%22%2C%0A%20%20%20%20%22fakedns%22%0A%20%20%5D%2C%0A%20%20%22metadataOnly%22%3A%20false%2C%0A%20%20%22routeOnly%22%3A%20false%0A%7D' --insecure
  curl -L "http://127.0.0.1:${port}${path}panel/inbound/add" -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.9' -H 'Connection: keep-alive' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Cookie: lang=en-US; session="'${session}'"' --data-raw 'up=0&down=0&total=0&remark=ss-tcp&enable=true&expiryTime=0&listen=&port='$4'&protocol=shadowsocks&settings=%7B%0A%20%20%22method%22%3A%20%22chacha20-ietf-poly1305%22%2C%0A%20%20%22password%22%3A%20%22xqHOezv9t5BlZ1vJ8IKJx%2F2oLWeOTNMKMbACLwi0PJM%3D%22%2C%0A%20%20%22network%22%3A%20%22tcp%2Cudp%22%2C%0A%20%20%22clients%22%3A%20%5B%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%22method%22%3A%20%22chacha20-ietf-poly1305%22%2C%0A%20%20%20%20%20%20%22password%22%3A%20%22NZ9xJU4T%2B0ZMJ56MSuZRTM8QC%2F86yoJDx3ss5Xded90%3D%22%2C%0A%20%20%20%20%20%20%22email%22%3A%20%22bhd6ujch%22%2C%0A%20%20%20%20%20%20%22limitIp%22%3A%200%2C%0A%20%20%20%20%20%20%22totalGB%22%3A%200%2C%0A%20%20%20%20%20%20%22expiryTime%22%3A%200%2C%0A%20%20%20%20%20%20%22enable%22%3A%20true%2C%0A%20%20%20%20%20%20%22tgId%22%3A%20%22%22%2C%0A%20%20%20%20%20%20%22subId%22%3A%20%22d5ugob6h4vm4wuwz%22%2C%0A%20%20%20%20%20%20%22reset%22%3A%200%0A%20%20%20%20%7D%0A%20%20%5D%0A%7D&streamSettings=%7B%0A%20%20%22network%22%3A%20%22tcp%22%2C%0A%20%20%22security%22%3A%20%22none%22%2C%0A%20%20%22externalProxy%22%3A%20%5B%5D%2C%0A%20%20%22tcpSettings%22%3A%20%7B%0A%20%20%20%20%22acceptProxyProtocol%22%3A%20false%2C%0A%20%20%20%20%22header%22%3A%20%7B%0A%20%20%20%20%20%20%22type%22%3A%20%22none%22%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D&sniffing=%7B%0A%20%20%22enabled%22%3A%20true%2C%0A%20%20%22destOverride%22%3A%20%5B%0A%20%20%20%20%22http%22%2C%0A%20%20%20%20%22tls%22%2C%0A%20%20%20%20%22quic%22%2C%0A%20%20%20%20%22fakedns%22%0A%20%20%5D%2C%0A%20%20%22metadataOnly%22%3A%20false%2C%0A%20%20%22routeOnly%22%3A%20false%0A%7D' --insecure
}

create_domain_cert() {
  configCertPath=/etc/cert/$1
  mkdir -p ${configCertPath}/
  ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
  ~/.acme.sh/acme.sh --register-account -m xxxx@xxxx.com
  ~/.acme.sh/acme.sh --issue -d $1 --standalone
  ~/.acme.sh/acme.sh --installcert -d $1 --key-file ${configCertPath}/private.key --fullchain-file ${configCertPath}/cert.crt
  echo "Config certificate public key saved in ${configCertPath}/cert.crt"
  echo "Config certificate private key saved in ${configCertPath}/private.key"
  cp ${configCertPath}/private.key /root/private.key
  cp ${configCertPath}/cert.crt /root/cert.crt
}

create_selfsigned_cert() {
  #sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /root/self.key -out /root/self.crt -subj '/C=US/O=Gamify/OU=Development/CN=[2001:2001:2001:2001:2001:2001:2001:2001]' -addext "basicConstraints = critical, CA:true, pathlen:0" -addext "subjectKeyIdentifier = hash" -addext "keyUsage = critical, keyCertSign, cRLSign" -addext "nameConstraints = permitted;IP:2001:2001:2001:2001:2001:2001:2001:2001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"
    #sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /root/self.key -out /root/self.crt -subj '/CN=[2001:2001:2001:2001:2001:2001:2001:2001]' -addext "basicConstraints = critical, CA:true, pathlen:0" -addext "subjectKeyIdentifier = hash" -addext "keyUsage = critical, keyCertSign, cRLSign" -addext "nameConstraints = permitted;IP:2001:2001:2001:2001:2001:2001:2001:2001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"
  configCertPath=/etc/cert/selfsigned
  mkdir -p ${configCertPath}/
  sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout ${configCertPath}/self.key -out ${configCertPath}/self.crt -subj '/CN=fast.com/O=Netflix, Inc.'
  cp ${configCertPath}/self.key /root/private.key
  cp ${configCertPath}/self.crt /root/cert.crt
}

create_cert() {
  if [[ $1 == "y" || $1 == "Y" ]]; then
    create_domain_cert $2
  else
    create_selfsigned_cert
  fi
}

config_panel() {
  #installing certificate on panel
  #/usr/local/x-ui/x-ui cert -webCert /root/cert.crt -webCertKey /root/private.key

  /usr/local/x-ui/x-ui setting -username admin -password $1
  /usr/local/x-ui/x-ui setting -webBasePath /${2}/
  /usr/local/x-ui/x-ui setting -port ${3}
  printf '11\n\n0\n' | x-ui > /dev/null
}

open_ports() {
  ufw allow ssh
  ufw allow 443
  ufw allow 80
  printf 'y\n' | ufw enable
  ufw reload
  echo "Port 80 and 443 are allowed now."
}

install_fake_site() {
  mkdir -p /var/www/html/
  cd /var/www/html
  git clone https://github.com/gd4Ark/2048.git 2048
  cd -
  echo "Downloaded the fake site."
}

install_nginx() {
  apt install nginx libnginx-mod-stream -y

  rm /etc/nginx/sites-enabled/default

  cat <<EOT >/etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;

events {
  worker_connections 768;
  multi_accept on;
}

http {
  server {
    listen 80;
    listen [::]:80;
    server_name _;
    return 301 https://\$host\$request_uri;
  }

  server {
    listen 127.0.0.1:20009 http2 proxy_protocol;
    server_name _;
    index index.html;
    root /var/www/html/2048;
  }

  server {
    listen 443 ssl; #reuseport ssl;
    listen [::]:443 ssl;
    server_name _;

    ssl_certificate /root/cert.crt;  # path to your SSL certificate
    ssl_certificate_key /root/private.key;  # path to your SSL certificate keiy

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location /$1/ {#panel
      proxy_pass http://127.0.0.1:$2;
      proxy_set_header Host \$host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location / {
      return 301 https://fast.com/;
    }

    #location / {
    #  root /var/www/html/2048;
    #  try_files \$uri \$uri/ =404;
    #}

  }
  sendfile on;
  #tcp_nopush on;
  types_hash_max_size 2048;
  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
  ssl_prefer_server_ciphers on;

  access_log /var/log/nginx/access.log;

  #gzip on;
}
EOT

  systemctl enable nginx
  systemctl restart nginx
}

PanelPass=$(head -c 12 /dev/urandom | base64)
URIPrefix=$(head -c 6 /dev/urandom | base64)
PPort=2053
ipv6Port=8080
grpcRealityPort=8443
ssPort=8880
obfuscatedHttpPort=24943

printf "Please note that only ports 443 and 80 and ssh will be opened after execution of this script."
printf "\n"
printf "Do you have a domain resolving to this server(y|n):"
printf "\n"
read -p "" hasDomain
echo $hasDomain
if [[ $hasDomain == "y" || $hasDomain == "Y" ]]; then
  printf "Please enter the panel domain:"
  printf "\n"
  read -p "" domain
  printf "Please make sure that ${domain} indicating to this server IP to be able to obtain certificate."
  printf "\npress any key to continue"
  read -p "" ignore
fi
update_server
install_dependencies
install_panel "$PPort"
add_inbounds "$ipv6Port" "$grpcRealityPort" "$obfuscatedHttpPort" "$ssPort"
create_cert "$hasDomain" "$domain"
config_panel "$PanelPass" "$URIPrefix" "$PPort"
install_fake_site
install_nginx "$URIPrefix" "$PPort"
ufw allow $ipv6Port
ufw allow $grpcRealityPort
ufw allow $obfuscatedHttpPort
ufw allow $ssPort
open_ports
printf '8\n' | x-ui
echo https://$(curl -s https://ipinfo.io/ip)/${URIPrefix}/
echo https://[$(curl -s -6 https://ifconfig.co)]/${URIPrefix}/

