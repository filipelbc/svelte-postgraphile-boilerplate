#!/bin/bash

set -e

result=$(mktemp)

./psql.sh -f ./check-plpgsql.sql -q | tee "$result"

grep -q '^(0 rows)$' "$result"
