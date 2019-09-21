#! /bin/bash
CONTAINER=$1
SCHEMA=$2
USER=$3


docker exec $CONTAINER pg_dump -U $USER $SCHEMA > backup.db