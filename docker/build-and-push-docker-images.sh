#!/bin/bash

set -ex

REGISTRY_ROOT=registry.gitlab.com/filipelbc/svelte-postgraphile-boilerplate

# Build "dev" docker image
docker build -t $REGISTRY_ROOT/dev:latest -f ./docker/Dockerfile.dev .

# Build "postgres" docker image
docker build -t $REGISTRY_ROOT/postgres:latest -f ./docker/Dockerfile.postgres .

# Upload to Gitlab CI
docker login registry.gitlab.com

docker push $REGISTRY_ROOT/dev:latest
docker push $REGISTRY_ROOT/postgres:latest
