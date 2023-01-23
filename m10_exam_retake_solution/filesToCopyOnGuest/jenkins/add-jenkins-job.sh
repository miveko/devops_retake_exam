#!/bin/bash

# 
# Create Jenkins job
# 

java -jar /home/vagrant/jenkins-cli.jar -s http://192.168.121.121:8080/ -http -auth admin:admin create-job exam_retake-app < /vagrant/jenkins/job.xml
