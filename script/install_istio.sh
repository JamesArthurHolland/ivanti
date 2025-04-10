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


  SECRET_NAME=ingress-cert-$ENV

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
  name: ivanti-gateway-$ENV
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
      tls:
        httpsRedirect: true
    - port:
        number: 443
        name: https-443
        protocol: HTTPS
      hosts:
        - "*.$DOMAIN"
        - "$DOMAIN"
      tls:
        credentialName: $SECRET_NAME # this should match with Certificate secretName
        mode: SIMPLE
END

echo "Apply redirect filter"

else #### ----------------- SSL DISABLED ----------------- ####
  echo "Installing istio with SSL disabled"

  kubectl label namespace "$NAMESPACE" istio-injection=enabled --overwrite


kubectl apply -f - <<END
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ivanti-gateway-local
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


echo "Installing istio access logging"

kubectl apply -f - <<END
apiVersion: telemetry.istio.io/v1alpha1
kind: Telemetry
metadata:
  name: mesh-default
  namespace: istio-system
spec:
  accessLogging:
    - providers:
      - name: envoy
END
