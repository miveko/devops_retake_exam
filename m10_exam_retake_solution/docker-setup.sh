#!/bin/bash

echo "********************************************************************"
echo "------------------Adding Docker and Docker Compose-----------------"
echo "********************************************************************"

echo "* Add any prerequisites ..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

echo "* Add Docker repository and key ..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "* Install Docker ..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant

echo "* Install Docker Compose"
mkdir -p /home/vagrant/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /home/vagrant/.docker/cli-plugins/docker-compose
chmod +x /home/vagrant/.docker/cli-plugins/docker-compose
chown -R vagrant:vagrant /home/vagrant/.docker

echo "* Copy the Compose plugin for root user"
mkdir -p /root/.docker/cli-plugins
cp /home/vagrant/.docker/cli-plugins/docker-compose /root/.docker/cli-plugins/

echo "* Change Docker configuration to expose Prometheus metrics"
cp /vagrant/docker/daemon.json /etc/docker/

echo "* Restart Docker to apply the changes"
systemctl restart docker
