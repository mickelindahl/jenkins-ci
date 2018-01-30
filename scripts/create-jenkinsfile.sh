#!/bin/bash

pwd
echo "Install packages"
read -p "Please enter secret file ID credential.txt uploaded as jenkins secret file): " secret_file_id

cp ./jenkins-ci/sample.Jenkinsfile Jenkinsfile
sed -i "s#{secret-file-id}#$secret_file_id#g" Jenkinsfile