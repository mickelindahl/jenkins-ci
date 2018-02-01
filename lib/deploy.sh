#!/usr/bin/env bash

. ./jenkins-ci/lib/assert.sh

assert "BRANCH_NAME" "JOB_NAME" "SITE_URL" "PATH_REMOTE_DEPLOY"

ssh -o $o -l $user $SITE_URL "mkdir -p $PATH_REMOTE_DEPLOY"
ssh -o $o -l $user $SITE_URL "
    cd $PATH_REMOTE_DEPLOY
    if [ -f build.docker-compose.yml ]; then

      docker-compose -f build.docker-compose.yml -p ${NAME} stop
      docker-compose -f build.docker-compose.yml -p ${NAME} rm -f
      ls -la
      mv build.docker-compose.yml previous.build.docker-compose.yml;

    fi
    "
scp -o $o build.docker-compose.yml jenkins@$SITE_URL:$PATH_REMOTE_DEPLOY
ssh -o $o -l $user $SITE_URL "
    cd $PATH_REMOTE_DEPLOY
    docker-compose -f build.docker-compose.yml -p ${NAME} stop
    docker-compose -f build.docker-compose.yml -p ${NAME} rm -f
    docker-compose -f build.docker-compose.yml -p ${NAME}  up -d
    "

echo "Test response"

TIME=0
OK=0
while [[ ( $TIME -le 60 ) && ( $OK -le 1 ) ]]; do

  sleep 5
  echo "Testing response $TIME seconds"

  TIME=$(( $TIME + 5 ))

  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://$SITE_URL")

  if [ "$STATUS_CODE" = "200" ]; then

    OK=1

  fi

done

if [ "$STATUS_CODE" = "200" ]; then

    echo "ok $STATUS_CODE"

else

    echo "Site responded with wrong status code $STATUS_CODE, should be 200"
    exit 1

fi