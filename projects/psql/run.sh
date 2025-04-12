#!/bin/bash

set -e

docker rm -f oneaddress_postgres || true

postgres_dir="$( dirname -- "$BASH_SOURCE"; )";
docker build --no-cache -t oneaddress_postgres -f "$postgres_dir/Dockerfile" .

docker run --rm -e POSTGRES_PASSWORD=pass1234 -e POSTGRES_DB=oneaddress --name oneaddress_postgres  -p 5432:5432 oneaddress_postgres
