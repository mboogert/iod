#!/bin/bash

cd /

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce docker-compose
yum -y install git

systemctl enable docker
systemctl start docker

ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone https://github.com/mboogert/iod.git

cd /iod ; docker-compose up -d

sleep 30

curl -X POST -d '{"name":"influxdb", "type":"influxdb", "url":"http://influxdb:8086", "access":"proxy", "database":"telegraf", "basicAuth":false}' -H 'Content-Type: application/json;charset=UTF-8' http://admin:admin@127.0.0.1/api/datasources/
