#!/bin/bash

PGPASSWORD="${POSTGRES_PASSWORD:-app_owner_password}" \
  psql \
  -v ON_ERROR_STOP=1 \
  -h "${POSTGRES_HOST:-postgres}" \
  -d "${POSTGRES_DB:-app}" \
  -U "${POSTGRES_USER:-app_owner}" \
  "$@"
