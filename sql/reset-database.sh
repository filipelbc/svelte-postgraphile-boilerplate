#!/bin/bash

set -e

. ./conn-string.sh

./psql.sh -d postgres \
  -c "drop database if exists $POSTGRES_DB;" \
  -c "create database $POSTGRES_DB;"

for f in $(find ./schema -name '*.sql' | sort)
do
  ./psql.sh -f "$f"
done
