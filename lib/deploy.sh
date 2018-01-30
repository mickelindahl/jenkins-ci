#!/usr/bin/env bash

. ./jenkins-ci/lib/assert.sh

assert "BRANCH_NAME" "JOB_NAME" "SITE_URL" "PATH_REMOTE_DEPLOY"

ssh -o $o -l $user $SITE_URL mkdir -p $PATH_REMOTE_DEPLOY
ssh -o $o -l $user $SITE_URL "
    cd $PATH_REMOTE_DEPLOY
    if [ -f build.docker-compose.yml ]; then
      docker-compose -f build.docker-compose.yml stop
      docker-compose -f build.docker-compose.yml rm
      mv build.docker-compose.yml previous.build.docker-compose.yml;

    fi
    "
scp -o $o build.docker-compose.yml jenkins@$SITE_URL:$PATH_REMOTE_DEPLOY
ssh -o $o -l $user $SITE_URL "
    cd $PATH_REMOTE_DEPLOY
    docker stop $NAME
    docker rm $NAME
    docker-compose -f build.docker-compose.yml up -d
    "

echo "Wait 10 seconds"
sleep 10

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://$SITE_URL")

if [ $STATUS_CODE=="200" ]; then

    echo "ok $STATUS_CODE"

else

    echo "Site responded with wrong status code $STATUS_CODE, should be 200"
    exit 1

fi