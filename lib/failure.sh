#!/usr/bin/env bash

if [ -f previous.build.docker-compose.yml ]; then

   o="StrictHostKeyChecking=no"
   user="jenkins"

   echo "Fallback to previous image"

   ssh -o $o -l $user $SITE_URL docker rmi $(docker images -f=reference='${NAME:${$TAG}' -q --no-trunc)
   ssh -o $o -l $user $SITE_URL mv previous.build.docker-compose.yml build.docker-compose.yml
   ssh -o $o -l $user $SITE_URL docker-compose -f build.docker-compose.yml up -d

fi