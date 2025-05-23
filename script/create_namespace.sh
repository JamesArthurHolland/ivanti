#!/bin/bash

NAMESPACE=$(echo $NAMESPACE | awk -F'/' '{print $1}')
echo "Creating namespace $NAMESPACE..."

if [ -n "$NAMESPACE" ]; then
  echo "Creating namespace $NAMESPACE"
  kubectl create ns "$NAMESPACE" || true
  export NAMESPACE
else
    printf "\n\n ERROR: NAMESPACE env var not set for k8s namespace creation."
    exit 1
fi