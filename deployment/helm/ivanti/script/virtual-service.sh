#!/bin/bash

export API_HOST=3632eab6f2dc2d627fd41ccfdff94df5-api.ivanti.test
export NAMESPACE=ivanti
if [ -z "$API_HOST" ]; then
  echo "No API_HOST found."
  exit 1
fi

# Create values.yaml with the necessary Helm values
cat << EOF > virtualservice.yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: $NAMESPACE.api
spec:
  hosts:
    - $API_HOST
  gateways:
    - istio-system/docker-registry-ivanti-gateway
  http:
    - route:
        - destination:
            host: ivanti-api.$NAMESPACE.svc.cluster.local
            port:
              number: 80
EOF

# Output the generated values for verification

cat virtualservice.yaml

kubectl apply -f virtualservice.yaml -n $NAMESPACE