#!/bin/bash

set -e

echo "sqlc generate"
sqlc generate

echo "---------"
echo "---------"
echo "sqlc-grpc"
echo "---------"
echo "---------"
sqlc-grpc -m "github.com/JamesArthurHolland/ivanti/counter"

go generate