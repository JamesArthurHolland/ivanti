#!/bin/bash

set -e

# kubectl label namespace default istio-injection=enabled

echo "-----------------------------------------------"
echo "---          Installing istio               ---"
echo "-----------------------------------------------"

kubectl apply -f deployment/istio/standard-install.yaml --validate=false

istioctl install -y

kubectl label namespace "$NAMESPACE" istio-injection=enabled --overwrite


echo "After istioctl"

if [[ -z "$NAMESPACE" ]]; then
  echo "\$NAMESPACE not set"
  exit 3
fi

echo "Namespace is $NAMESPACE"
kubectl label namespace "${NAMESPACE}" istio-injection=enabled --overwrite

echo "After label"

if [[ -z "$DOMAIN" ]]; then
  echo "\$DOMAIN not set"
  exit 3
fi


if [[ -z "$ENV" ]]; then
  echo "\$ENV not set"
  exit 3
fi

kubectl apply -f - <<END
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: docker-registry-ivanti-gateway
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
        - "*.ivanti.test"
        - "*.ivanti.com"
END

echo "Istio installed"


