#!/bin/bash

check_docker_tag() {
    IMAGE_NAME=$1
    TAG_NAME=$2

    # Docker Hub API URL
    URL="https://hub.docker.com/v2/repositories/ozone2021/api/tags/"

    # Check if the tag exists
    if curl -X GET -H "Authorization: Bearer dckr_pat_Wg5wkmThOwxGhdgiw5pQba7JMS4" "$URL" | grep -q "\"name\":\"$TAG_NAME\""; then
        echo "Tag '$TAG_NAME' exists for image '$IMAGE_NAME'."
        return 0
    else
        echo "Tag '$TAG_NAME' does not exist for image '$IMAGE_NAME'."
        return 3
    fi
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <image-name> <tag-name>"
    exit 3
fi

# Call the function with arguments
check_docker_tag "$1" "$2"