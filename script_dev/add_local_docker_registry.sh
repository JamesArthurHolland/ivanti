#!/bin/bash

echo "---                            ---"
echo "--- Installing Docker registry ---"
echo "---                            ---"

kubectl get po --all-namespaces | grep -q docker-registry


set -e

helm repo add twuni https://helm.twun.io || true

helm upgrade -i --set ingress.enabled=false \
  --namespace docker-registry \
  --create-namespace \
  --set persistence.enabled=true \
  --set persistence.size=40Gi \
  docker-registry twuni/docker-registry || true

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

kubectl apply -n docker-registry -f - <<END
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: docker-registry-ivanti-virtualservice
spec:
  hosts:
    - ivanti.local
  gateways:
    - istio-system/docker-registry-ivanti-gateway-local
  http:
    - route:
        - destination:
            host: docker-registry.docker-registry.svc.cluster.local
            port:
              number: 5000
END

