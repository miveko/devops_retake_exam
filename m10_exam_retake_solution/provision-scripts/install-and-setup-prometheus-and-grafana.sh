#!/bin/bash

echo "********************************************************************"
echo "------------------------Installing Prometheus-----------------------"
echo "********************************************************************"
echo ""
cd /home/vagrant
wget https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz
tar xzvf prometheus-2.39.1.linux-amd64.tar.gz

echo "********************************************************************"
echo "-----------------Configuring and starting Prometheus----------------"
echo "********************************************************************"
echo ""
cd prometheus-2.39.1.linux-amd64
cp prometheus.yml prometheus.yml.bak
cp /vagrant/monitoring/prometheus.yml /home/vagrant/prometheus-2.39.1.linux-amd64/prometheus.yml
./promtool check config prometheus.yml
lsof -ti :9090 | xargs kill -9
cd cd /home/vagrant/prometheus-2.39.1.linux-amd64
./prometheus --config.file prometheus.yml --web.enable-lifecycle  --web.listen-address=:9090 2>> /tmp/prometheus.log &
curl -X POST http://192.168.121.123:9090/-/reload


echo "********************************************************************"
echo "-------------------------Installing Grafana-------------------------"
echo "********************************************************************"
echo ""
cd /home/vagrant
wget https://dl.grafana.com/oss/release/grafana-9.2.4.linux-amd64.tar.gz
tar -zxvf grafana-9.2.4.linux-amd64.tar.gz

echo "********************************************************************"
echo "-------------------Configuring and starting Grafana-----------------"
echo "********************************************************************"
echo ""
cd grafana-9.2.4/
sudo timedatectl set-ntp on
lsof -ti :3000 | xargs kill -9
cd /home/vagrant/grafana-9.2.4/
./bin/grafana-server web >> /tmp/grafana.log 2>&1 &

sleep 30

echo "Adding an API key for user admin"
export KEY=$(curl -X POST -H "Content-Type: application/json"  -H "Accept: application/json"   http://admin:admin@localhost:3000/api/auth/keys -d '{"name":"admin","role":"Admin","secondsToLive":86400}'  | jq '.key' | sed 's/"//g' )

echo "Adding the Prometheus data source"
curl -X POST -H "Content-Type: application/json"  -H "Accept: application/json"   http://api_key:$(echo $KEY)@localhost:3000/api/datasources -d '{"name":"Prometheus local","type":"prometheus","url":"http://192.168.121.123:9090","access":"proxy","basicAuth":false}'

echo "Importing a dashboard"
export DASHBID=$(curl -X POST -H "Content-Type: application/json"  -H "Accept: application/json"  http://api_key:$(echo $KEY)@localhost:3000/api/dashboards/import -d "$(cat /vagrant/monitoring/dashboard_imp.json)"  | jq '.uid' | sed 's/"//g' )

echo "Importing the dashboard panels"
curl -X POST -H "Content-Type: application/json"  -H "Accept: application/json"  http://api_key:$(echo $KEY)@localhost:3000/api/ds/query -d "$(cat /vagrant/monitoring/panel_1.json)"
curl -X POST -H "Content-Type: application/json"  -H "Accept: application/json"  http://api_key:$(echo $KEY)@localhost:3000/api/ds/query -d "$(cat /vagrant/monitoring/panel_2.json)"
curl -X POST -H "Content-Type: application/json"  -H "Accept: application/json"  http://api_key:$(echo $KEY)@localhost:3000/api/ds/query -d "$(cat /vagrant/monitoring/panel_3.json)"
