#!/bin/bash

set -e

db_name=${POSTGRES_DB:-app}

./psql.sh -d postgres \
  -c "drop database if exists $db_name;" \
  -c "create database $db_name;"

for f in $(find ./schema -name '*.sql' | sort)
do
  ./psql.sh -f "$f"
done
