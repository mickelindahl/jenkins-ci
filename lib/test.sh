#!/usr/bin/env bash

. ./jenkins-ci/lib/assert.sh

assert "NAME" "TAG"

echo "NAME:TAG=$NAME:$TAG"

cp sample.env .env

TEST_NAME="test-$NAME"

sed -i "s/{admin-pass}/secret/g" .env && \
sed -i "s/{db-host}/$TEST_NAME-db/g" .env && \
sed -i "s/{db-user}/app/g" .env && \
sed -i "s/{db-name}/app/g" .env && \
sed -i "s/{db-pass}/secret/g" .env && \
sed -i "s/{db-port}/5432/g" .env && \
sed -i "s/{facebook-app-id}/dummy/g" .env && \
sed -i "s/{google-client-id}/dummy/g" .env && \
sed -i "s/{house-pass}/secret/g" .env && \
sed -i "s/{host}/0.0.0.0/g" .env && \
sed -i "s#{mailgun-api-key}#dummy#g" .env && \
sed -i "s#{site}#dummy#g" .env

cp sample.docker-compose.yml test.docker-compose.yml

sed -i "s/{command}/npm test/g" test.docker-compose.yml
sed -i "s/{tty}/false/g" test.docker-compose.yml
sed -i 's/{restart}/"no"/g' test.docker-compose.yml
sed -i "s/{NAME}/$TEST_NAME/g" test.docker-compose.yml
sed -i "s/{TAG}/$TAG/g" test.docker-compose.yml
sed -i 's/{SITE_URL}/dummy/g' test.docker-compose.yml
sed -i 's/{DB_PASS}/secret/g' test.docker-compose.yml
sed -i "s/{DB_EXTERNAL_PORT}/$DB_EXTERNAL_PORT_TEST/g" test.docker-compose.yml


#for var in $COMPOSE_VARS_TEST; do
#
#    sed -i $(eval echo "s/{$var}/\$$var/g") test.docker-compose.yml
#
#done

docker-compose -f test.docker-compose.yml -p ${TEST_NAME} build
docker-compose -f test.docker-compose.yml -p ${TEST_NAME} stop
docker-compose -f test.docker-compose.yml -p ${TEST_NAME} rm -f

echo "Start test container"
docker-compose -f test.docker-compose.yml -p ${TEST_NAME} up -d

docker logs -f $TEST_NAME 2>&1 | tee test.log
docker wait $TEST_NAME

echo "Remove .env"
rm .env

a=`cat test.log`
flag=`echo $a|awk '{print match($0,"tests failed")}'`;

# Remove old test images
. ./jenkins-ci/lib/success.sh $TEST_NAME $TAG

if [ $flag -gt 0 ];then

    echo "failed tests $flag";
    exit 1

else

    echo "Success";

fi
