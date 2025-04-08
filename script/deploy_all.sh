#!/bin/bash

set -e

SCRIPT_DIR=$(dirname $0)
. ./script/tf_init.sh

echo "#--------------------------------------------------"
echo "# Terraform provision kubernetes cluster"
echo "#--------------------------------------------------"



tf apply \
      -auto-approve -var-file="terraform.tfvars" \
      -var="name=$NAME" \
      -var="label=${NAME_HYPHEN}ivanti-lke-cluster"

echo "terraform applied... "

sleep 200s

## On mac the base64 arg is -D

tf output kubeconfig | tr -d '"' | base64 -d > "$KUBECONFIG"

echo "KUBECONFIG $(tf output kubeconfig | tr -d '"' | base64 -d)"

echo "#--------------------------------------------------"
echo "# Deploy nginx ingress"
echo "#--------------------------------------------------"

helm upgrade --install --wait ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

echo "Ingressed installed. Sleep until loadBalancer up."
sleep 200s

echo "Get ingress IP"
export INGRESS_EXT_IP=$(kubectl --namespace ingress-nginx get services -o wide ingress-nginx-controller \
      -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "#--------------------------------------------------"
echo "# Deploy service helm charts"
echo "#--------------------------------------------------"

echo "KUBECONFIG: $KUBECONFIG"
echo "Ingress IP: $INGRESS_EXT_IP"
echo "Add to your hosts file: \n $INGRESS_EXT_IP  $NAME.ivantiwordpress.com"