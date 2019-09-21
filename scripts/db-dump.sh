#! /bin/bash
CONTAINER=$1

# Backup:
docker exec -t -u postgres $CONTAINER pg_dumpall -c > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

