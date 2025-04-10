#!/bin/bash

echo "Creating namespace $NAMESPACE..."

if [ -n "$NAMESPACE" ]; then
  echo "Creating namespace $NAMESPACE"
  kubectl create ns "$NAMESPACE" || true
else
    printf "\n\n ERROR: NAMESPACE env var not set for k8s namespace creation."
    exit 1
fi