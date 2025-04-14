#!/bin/bash

echo "---                   ---"
echo "--- Postman e2e tests ---"
echo "---                   ---"

if [[ -z "$API_HOST" ]]; then
  echo "\$API_HOST not set"
  exit 3
fi

NEWMAN_RESULT=$(newman run --verbose $ROOT_DIR/tests/postman/run/e2e-tests.postman_collection.json \
  --env-var "endpoint=$API_HOST")

# Check if there are any test failures in the Newman result
if echo "$NEWMAN_RESULT" | grep -q "failures="; then
  echo "Tests failed."
  exit 1  # Exit with a non-zero status to indicate failure
else
  echo "Tests passed."
fi

