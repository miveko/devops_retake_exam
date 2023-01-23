#!/bin/bash

echo "********************************************************************"
echo "---------------Installing and configuring Elasticsearch-------------"
echo "********************************************************************"
echo ""
cd /home/vagrant
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.5.0-amd64.deb
sudo dpkg -i elasticsearch-8.5.0-amd64.deb | tee elsearch_isntall.log
echo "-Xms2g" >> jvm.options
echo "-Xmx2g" >> jvm.options
mv jvm.options /etc/elasticsearch/jvm.options.d/jvm.options
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.bak
cp /vagrant/monitoring/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
#>cluster.name: mycluster	(line #17) 
#>node.name: monitoring (line #23)
#>network.host: ["localhost", "192.168.99.101"] (line #56)
#>http.port:9200 (line #61)
#>xpack.security.enabled: false (row #98)
#>#cluster.initial_master_nodes: ["monitoring"] (line #74) 
#>cluster.initial_master_nodes: ["monitoring"] (line #115)


echo "********************************************************************"
echo "----------------Installing and configuring Logstash-----------------"
echo "********************************************************************"
echo ""
cd /home/vagrant
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.5.0-amd64.deb
sudo dpkg -i logstash-*.deb | tee logstash_isntall.log
echo "-Xms512m" > jvm.options 
echo "-Xmx512m" >> jvm.options 
mkdir /etc/logstash/jvm.options.d
mv jvm.options /etc/logstash/jvm.options.d/jvm.options
cp /etc/logstash/conf.d/beats.conf /etc/logstash/conf.d/beats.conf.bak
cp /vagrant/monitoring/beats.conf /etc/logstash/conf.d/beats.conf


echo "********************************************************************"
echo "-----------------Installing and configuring Kibana------------------"
echo "********************************************************************"
echo ""
cd /home/vagrant
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.5.0-amd64.deb
sudo dpkg -i kibana-8.5.0-amd64.deb | tee kibana_isntall.log
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml.bak
cp /vagrant/monitoring/kibana.yml /etc/kibana/kibana.yml
#>server.port: 5601 (line #6) 
#>server.host: "192.168.121.123"	(line #11) 
#>server.name: "monitoring"	(line #32) 
#>elasticsearch.hosts: ["http://localhost:9200"] (line #43)

#echo "* Start the services"
#sudo systemctl daemon-reload
#sudo systemctl restart elasticsearch
#sudo systemctl restart logstash
#sudo systemctl restart kibana

echo "* Start the services"
systemctl daemon-reload
systemctl enable --now elasticsearch
systemctl enable --now logstash
systemctl enable --now kibana
