#!/bin/bash

. ./conn-string.sh

PGPASSWORD="$POSTGRES_PASSWORD" \
  psql \
  -v ON_ERROR_STOP=1 \
  -h "$POSTGRES_HOST" \
  -d "$POSTGRES_DB" \
  -U "$POSTGRES_USER" \
  "$@"
