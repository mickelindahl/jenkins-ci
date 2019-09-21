#! /bin/bash

$DUMP=$1
$CONTAINER=$2

# Restore:
cat $DUMP | docker exec -i $CONTAINER psql -Upostgres


