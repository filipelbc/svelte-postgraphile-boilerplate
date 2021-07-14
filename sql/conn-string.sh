#!/bin/bash

export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-app_owner_password}
export POSTGRES_HOST=${POSTGRES_HOST:-postgres}
export POSTGRES_DB=${POSTGRES_DB:-app}
export POSTGRES_USER=${POSTGRES_USER:-app_owner}
