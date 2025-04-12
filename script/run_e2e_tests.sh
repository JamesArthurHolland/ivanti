#!/bin/bash

echo "---                   ---"
echo "--- Postman e2e tests ---"
echo "---                   ---"

if [[ -z "$API_HOST" ]]; then
  echo "\$API_HOST not set"
  exit 3
fi

set -e

source $(dirname "$0")/vars/vars.sh


newman run --verbose $ROOT_DIR/tests/postman/run/user_and_eprofile.postman_collection.json \
  --env-var "jwt=$TOKEN" \
  --env-var "api_url=${api_url_with_protocol}"

# TODO set timeout for crewchange tests to stop infinite loop.

