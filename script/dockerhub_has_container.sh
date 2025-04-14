#!/bin/bash

if [[ -z "$DOCKER_PASSWORD" ]]; then
  echo "\$DOCKER_PASSWORD not set"
  exit 3
fi

check_docker_tag() {
    IFS=':' read -r IMAGE_NAME TAG_NAME <<< "$DOCKER_FULL_TAG"

    echo "Checking if tag '$TAG_NAME' exists for image '$IMAGE_NAME'..."

    # Docker Hub API URL
    URL="https://hub.docker.com/v2/repositories/ozone2021/api/tags/"

    # Check if the tag exists
    if curl -X GET -H "Authorization: Bearer $DOCKER_PASSWORD" "$URL" | grep -q "\"name\":\"$TAG_NAME\""; then
        echo "Tag '$TAG_NAME' exists for image '$IMAGE_NAME'."
        return 0
    else
        echo "Tag '$TAG_NAME' does not exist for image '$IMAGE_NAME'."
        return 3
    fi
}

check_docker_tag
