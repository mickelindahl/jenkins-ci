#!/usr/bin/env bash

IMAGES=$(docker images -f 'dangling=true' -q --no-trunc);
IMAGES=$(echo $IMAGES | tr '\n' ' ')
IMAGES=$(echo -e "${IMAGES}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

echo "IMAGES:i-$IMAGES-i"

if [ ! "$IMAGES" = "" ]; then

    docker rmi -f ${IMAGES};

fi
