#!/bin/bash

IP_ADDRESS=$(kubectl get svc istio-ingressgateway -n istio-system -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ -z "$API_HOST" ]; then
  echo "No API_HOST found."
  exit 3
fi

if [ -z "$IP_ADDRESS" ]; then
  echo "No IP_ADDRESS found."
  exit 3
fi

echo "API_HOST IS $API_HOST"

if ! grep -q "$API_HOST" /etc/hosts; then
  echo "$IP_ADDRESS    $API_HOST" | sudo tee -a /etc/hosts > /dev/null
  echo "Added $IP_ADDRESS $API_HOST to /etc/hosts."
else
  echo "$API_HOST already exists in /etc/hosts."
fi