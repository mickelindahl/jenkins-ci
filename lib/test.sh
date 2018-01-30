#!/usr/bin/env bash

. ./ci/lib/assert.sh

assert "APP_NAME" "BRANCH_NAME" "SITE_URL"

cp sample.docker-compose.yml test.docker-compose.yml

NAME="test-$APP_NAME-$BRANCH_NAME"

sed -i "s/{command}/npm test/g" test.docker-compose.yml
sed -i "s/{tty}/false/g" test.docker-compose.yml
sed -i 's/{restart}/"no"/g' test.docker-compose.yml
sed -i 's/{TAG}/jenkins/g' test.docker-compose.yml
sed -i 's/{SITE_URL}/dummy/g' test.docker-compose.yml

for var in $COMPOSE_VARS_TEST; do

    sed -i $(eval echo "s/{$var}/\$$var/g") test.docker-compose.yml

done

docker-compose -f test.docker-compose.yml build
docker-compose -f test.docker-compose.yml up -d

docker logs -f $NAME
docker wait $NAME