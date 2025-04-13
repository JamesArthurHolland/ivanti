#!/bin/bash

DOCKER_REPO=$1

if [ -z "$DOCKER_REPO" ]
then
  echo "get_image_tag.sh: DOCKER_REPO not set."
  exit 1
fi
echo "TODO remove: 4"


case $ENV in
  "PROD")
    branch=$(git log -1 --pretty=%B | grep -o "release\\/.*")
    ;;
  "DEV")
    branch="$GITHUB_HEAD_REF"
    ;;
  *)
    echo "ENV should be \"PROD\" or \"DEV\""
    exit 1
esac

echo "Branch is $branch"

if [ -z "$branch" ]
then
  echo "get_image_tag.sh: DOCKER_REPO not set."
  exit 1
fi
echo "TODO remove: 4"

version=$("$UTILS_DIR"/get_release_version.py "$branch")

if [ $? -ne 0 ]; then
    echo "Version issue: $version"
    exit 1
fi

echo "TODO remove: 6"

export DOCKER_TAG=$version
export DOCKER_IMAGE="$DOCKER_REPO:$DOCKER_TAG"