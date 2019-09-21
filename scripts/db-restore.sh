#! /bin/bash

docker exec $CONTAINER pg_restore -U -d $DB_NAME $USER $SCHEMA > backup.db
 -d $DB_NAME /path/to/your/file/dump_name.tar -c -U db_user

