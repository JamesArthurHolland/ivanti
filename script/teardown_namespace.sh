#!/bin/bash

echo "Tearing down namespace $NAMESPACE"
kubectl delete ns "$NAMESPACE"