#!/usr/bin/env bash

. ./jenkins-ci/lib/assert.sh

assert "ADMIN_PASS" "COMMAND" "DB_PASS" "DB_EXTERNAL_PORT"
assert "FACEBOOK_APP_ID" "GOOGLE_CLIENT_ID"
assert "HOUSE_PASS" "MAILGUN_API_KEY" "NAME" "SITE_URL" "TAG"

cp sample.env .env

sed -i "s/{admin-pass}/$ADMIN_PASS/g" .env && \
sed -i "s/{db-host}/$NAME-db/g" .env && \
sed -i "s/{db-user}/app/g" .env && \
sed -i "s/{db-name}/app/g" .env && \
sed -i "s/{db-pass}/$DB_PASS/g" .env && \
sed -i "s/{db-port}/5432/g" .env && \
sed -i "s/{facebook-app-id}/$FACEBOOK_APP_ID/g" .env && \
sed -i "s/{google-client-id}/$GOOGLE_CLIENT_ID/g" .env && \
sed -i "s/{house-pass}/$HOUSE_PASS/g" .env && \
sed -i "s/{host}/0.0.0.0/g" .env && \
sed -i "s#{mailgun-api-key}#$MAILGUN_API_KEY#g" .env && \
sed -i "s#{site}#$SITE_URL#g" .env

cp sample.docker-compose.yml build.docker-compose.yml

sed -i "s/{command}/$COMMAND/g" build.docker-compose.yml
sed -i "s/{tty}/true/g" build.docker-compose.yml
sed -i 's/{restart}/"always"/g' build.docker-compose.yml
sed -i "s/{IMAGE}/$NAME/g" build.docker-compose.yml
sed -i "s/{CONTAINER}/$NAME/g" build.docker-compose.yml
sed -i "s/{TAG}/$TAG/g" build.docker-compose.yml
sed -i "s/{SITE_URL}/$SITE_URL/g" build.docker-compose.yml
sed -i "s/{DB_PASS}/$DB_PASS/g" build.docker-compose.yml
sed -i "s/{DB_EXTERNAL_PORT}/$DB_EXTERNAL_PORT/g" build.docker-compose.yml


#for var in $COMPOSE_VARS_BUILD; do
#
#    sed -i $(eval echo "s/{$var}/\$$var/g") build.docker-compose.yml
#
#done

docker-compose -f build.docker-compose.yml build

echo "Remove .env"
rm .env