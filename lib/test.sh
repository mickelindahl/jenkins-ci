#!/usr/bin/env bash

echo "BN: $BRANCH_NAME"

. ./jenkins-ci/lib/assert.sh

echo "BN: $BRANCH_NAME"

assert "APP_NAME" "BRANCH_NAME" "SITE_URL"

cp sample.docker-compose.yml test.docker-compose.yml

NAME="test-$APP_NAME-$BRANCH_NAME"
DB_NAME="test-$DB_NAME"


sed -i "s/{command}/npm test/g" test.docker-compose.yml
sed -i "s/{tty}/false/g" test.docker-compose.yml
sed -i 's/{restart}/"no"/g' test.docker-compose.yml
sed -i "s/{NAME}/$NAME/g" test.docker-compose.yml
sed -i "s/{TAG}/$TAG/g" test.docker-compose.yml
sed -i 's/{SITE_URL}/dummy/g' test.docker-compose.yml
sed -i "s/{DB_NAME}/$DB_NAME/g" test.docker-compose.yml
sed -i 's/{DB_PASS}/secret/g' test.docker-compose.yml
sed -i 's/{DB_EXTERNAL_PORT}/5999/g' test.docker-compose.yml
sed -i 's/{FACEBOOK_APP_ID}/dummy/g' test.docker-compose.yml
sed -i 's/{FACEBOOK_APP_SECRET}/dummy/g' test.docker-compose.yml
sed -i 's/{GOOGLE_CLIENT_ID}/dummy/g' test.docker-compose.yml
sed -i 's/{ADMIN_PASS}/secret/g' test.docker-compose.yml


for var in $COMPOSE_VARS_TEST; do

    sed -i $(eval echo "s/{$var}/\$$var/g") test.docker-compose.yml

done

docker-compose -f test.docker-compose.yml -p ${NAME} build
docker-compose -f test.docker-compose.yml -p ${NAME} stop
docker-compose -f test.docker-compose.yml -p ${NAME} rm -f

echo "Start test container"
docker-compose -f test.docker-compose.yml -p ${NAME} up -d

docker logs -f $NAME
docker wait $NAME

# Remove old test images
. ./jenkins-ci/lib/success.sh $NAME $TAG