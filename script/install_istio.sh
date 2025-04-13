#!/bin/bash

set -e

# kubectl label namespace default istio-injection=enabled

echo "-----------------------------------------------"
echo "---          Installing istio               ---"
echo "-----------------------------------------------"

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v0.7.1/standard-install.yaml

istioctl install -y

echo "After istioctl"

if [[ "$SSL_ENABLED" == "true" ]]; then
  echo "Installing istio with SSL enabled"

  kubectl label namespace "$NAMESPACE" istio-injection=enabled --overwrite


  if [[ -z "$DOMAIN" ]]; then
    echo "\$DOMAIN not set"
    exit 3
  fi

  if [[ -z "$ENV" ]]; then
    echo "\$ENV not set"
    exit 3
  fi

# TODO double check "allowedRoutes" below https://www.danielstechblog.io/configuring-istio-using-the-kubernetes-gateway-api/

kubectl apply -f - <<END
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: docker-registry-ivanti-gateway-local
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
    - port:
        number: 80
        name: http
        protocol: HTTP
      hosts:
        - "*.$DOMAIN"
        - "$DOMAIN"
END
fi
