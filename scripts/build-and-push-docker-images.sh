#!/bin/bash

set -ex

REGISTRY_ROOT=registry.gitlab.com/filipelbc/svelte-postgraphile-boilerplate

# Build "dev" docker image
docker build -t $REGISTRY_ROOT/dev:latest .

# Also store PostgreSQL image in the Gitlab Registry
docker pull postgres:13
docker tag postgres:13 $REGISTRY_ROOT/postgres:latest

# Upload to Gitlab CI
docker login registry.gitlab.com

docker push $REGISTRY_ROOT/dev:latest
docker push $REGISTRY_ROOT/postgres:latest
