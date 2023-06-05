#!/bin/bash

openssl req -newkey rsa:2048 -nodes -out server.csr -keyout server.key -subj "/C=US/ST=Oregon/L=Springfield/O=company/OU=company-unit/CN=127.0.0.1"
openssl x509 -sha256 -req -extfile <(printf "subjectAltName=IP:127.0.0.1") -days 365 -in server.csr -out server-signed.crt -signkey server.key
cat server-signed.crt server.key > server.pem
