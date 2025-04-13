#!/bin/bash

exit 0
echo TODO

echo "---                   ---"
echo "--- Postman e2e tests ---"
echo "---                   ---"

if [[ -z "$API_HOST" ]]; then
  echo "\$API_HOST not set"
  exit 3
fi

set -e

source $(dirname "$0")/vars/vars.sh


newman run --verbose $ROOT_DIR/tests/postman/run/e2e-tests.postman_collection.json \
  --env-var "endpoint=$API_HOST"

# TODO set timeout for crewchange tests to stop infinite loop.

