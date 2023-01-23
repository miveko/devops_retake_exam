#!/bin/bash

echo ""
echo "********************************************************************"
echo "-----------------------Installing NodeExporter----------------------"
echo "********************************************************************"
cd ~
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz 
tar xzvf node_exporter-1.4.0.linux-amd64.tar.gz
cd node_exporter-1.4.0.linux-amd64/
./node_exporter   &> node-exporter.log &