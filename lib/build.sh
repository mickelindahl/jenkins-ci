#!/usr/bin/env bash

. ./ci/lib/assert.sh

assert "APP_NAME" "BRANCH_NAME" "BUILD_ID" "SITE_URL"

cp sample.docker-compose.yml build.docker-compose.yml

sed -i "s/{command}/node index/g" build.docker-compose.yml
sed -i "s/{tty}/true/g" build.docker-compose.yml
sed -i "s/{restart}/always/g" build.docker-compose.yml


for var in $COMPOSE_VARS_BUILD; do

    sed -i $(eval echo "s/{$var}/\$$var/g") build.docker-compose.yml

done

docker-compose -f build.docker-compose.yml build