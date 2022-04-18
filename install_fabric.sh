#!/bin/bash

#Set appropriate DNS if scripts couldn't resolve domains
sudo yum update -y
sudo yum install git curl -y

#Check docker
if ! command -v docker &> /dev/null
then
    curl -sSL https://raw.githubusercontent.com/MaisamV/CentosMinimalScripts/master/install_docker.sh | bash -s
fi

#Check docker_compose
if ! command -v docker-compose &> /dev/null
then
    curl -sSL https://raw.githubusercontent.com/MaisamV/CentosMinimalScripts/master/install_docker_compose.sh | bash -s
fi

#Check go
if ! command -v go &> /dev/null
then
    curl -sSL https://raw.githubusercontent.com/MaisamV/CentosMinimalScripts/master/install_go18.sh | bash -s
fi

#Install samples, binaries and dokcer images
curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/release-2.2/scripts/bootstrap.sh | bash -s -- 2.2.5 1.5.2
