#!/bin/bash

if [[ -z "$DOCKER_CONTAINER_VERSION_TAG" ]]; then
  echo "\$DOCKER_CONTAINER_VERSION_TAG not set"
  exit 3
fi

if [[ -z "$DOCKER_REGISTRY" ]]; then
  echo "\$DOCKER_REGISTRY not set"
  exit 3
fi

if [[ -z "$SERVICE" ]]; then
  echo "\$SERVICE not set"
  exit 3
fi

REPO="$SERVICE"

TOKEN=$(aws ecr get-authorization-token --region eu-west-1 --output text --query 'authorizationData[].authorizationToken')

if [[ $? != 0 ]]; then
  exit 3
fi
echo "Got token"

exec 3>&1
HTTP_STATUS=$(curl -k -w "%{http_code}" -o >(cat >&3) -H "Authorization: Basic $TOKEN" "https://$DOCKER_REGISTRY/v2/$REPO/tags/list" )

if [[ "$HTTP_STATUS" -ne "200" ]]; then
  echo ""
  echo ""
  echo "Curl response code: $curlResponseCode"
  echo "Does REPO $REPO exist in aws ecr? $DOCKER_REGISTRY"
  exit 3
fi

curl -k -sS -H "Authorization: Basic $TOKEN" "https://$DOCKER_REGISTRY/v2/$REPO/tags/list" | grep -w -q "$DOCKER_CONTAINER_VERSION_TAG"

outcome=$?
if [[ $outcome == 0 ]]; then
  echo "\n"
  echo "--------------------------------------------------------"
  echo "Tag $DOCKER_REGISTRY/$REPO:$DOCKER_CONTAINER_VERSION_TAG exists in docker registry."
  echo "--------------------------------------------------------"
elif [[ $outcome != 0 ]]; then
  echo "\n"
  echo "--------------------------------------------------------"
  echo "404: Tag $DOCKER_REGISTRY/$REPO:$DOCKER_CONTAINER_VERSION_TAG not found."
  echo "--------------------------------------------------------"
fi
exit $outcome
