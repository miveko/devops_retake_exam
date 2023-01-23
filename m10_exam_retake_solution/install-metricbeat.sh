#!/bin/bash

echo ""
echo "********************************************************************"
echo "----------------------------Beats---------------------------"
echo "********************************************************************"
echo "Downloading and installing metricbeat"
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.5.0-amd64.deb
sudo dpkg -i metricbeat-8.5.0-amd64.deb

sudo cp /vagrant/monitoring/metricbeat.yml 	/etc/metricbeat/metricbeat.yml

metricbeat modules enable system

metricbeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["192.168.121.123:9200"]'

metricbeat modules enable docker

cp cp /vagrant/monitoring/docker.yml	/etc/metricbeat/modules.d/docker.yml

echo "* Enable and start the beat"
systemctl daemon-reload
systemctl enable --now metricbeat


echo '* Create the Index Patterns ...'
curl -X POST http://monitoring:5601/api/index_patterns/index_pattern  -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"index_pattern": {"title": "metricbeat-*", "timeFieldName":"@timestamp"}}'
curl -X POST http://monitoring:5601/api/index_patterns/index_pattern  -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"index_pattern": {"title": "docker-*", "timeFieldName":"@timestamp"}}'
