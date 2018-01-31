#!/usr/bin/env bash

IMAGES=$(docker images -f 'dangling=true' -q --no-trunc);
IMAGES=$(echo $IMAGES | tr '\n' ' ')

if [ ! "$IMAGES" = "" ]; then

    docker rmi ${IMAGES};

fi
