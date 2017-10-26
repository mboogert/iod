#!/bin/bash

USERPASS="${1:-password}"
EXTERNAL_IP="$(/usr/bin/curl -s http://ip.tyk.nu)"

cd /

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce docker-compose git certbot

systemctl enable docker ; systemctl start docker

ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone https://github.com/mboogert/iod.git

certbot certonly -d iod.proserve.nl --standalone --agree-tos --email support@proserve.nl -n

cd /iod ; docker-compose up -d

grafana_status(){ curl -s -I http://localhost/login | head -n1 | grep "200 OK"; }

until grafana_status
do
  echo "Waiting for grafana availability..."
  sleep 1
done

curl -X POST -d '{"name":"influxdb", "type":"influxdb", "url":"http://influxdb:8086", "access":"proxy", "database":"telegraf", "basicAuth":false}' -H 'Content-Type: application/json;charset=UTF-8' http://admin:admin@localhost/api/datasources/
curl -X POST -d @/iod/linux-dashboard.json -H 'Content-Type: application/json;charset=UTF-8' http://admin:admin@localhost/api/dashboards/db
curl -X POST -d @/iod/windows-dashboard.json -H 'Content-Type: application/json;charset=UTF-8' http://admin:admin@localhost/api/dashboards/db
curl -X POST -d '{"name": "user", "login":"user", "password":"'"$USERPASS"'"}' -H 'Content-Type: application/json;charset=UTF-8' http://admin:admin@localhost/api/admin/users

