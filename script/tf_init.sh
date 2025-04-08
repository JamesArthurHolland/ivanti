#!/bin/bash

export NAME="shared"
export NAME_HYPHEN="$NAME-"
export NAME_DOT="$NAME."

mkdir $HOME/k8s || true
export KUBECONFIG="$HOME/k8s/lke-cluster-config.yaml"

if [ "$NAME" == "main" ]; then
  export NAME_DOT=""
  export NAME_HYPHEN=""
fi

env | grep NAME

if [ "$NAME" == "" ]; then
  echo "NAME must be set"
  exit 1
fi

if [ "$IVANTI_STATE_S3_ACCESS" == "" ]; then
  echo "NAME must be set"
  exit 1
fi

if [ "$IVANTI_STATE_S3_SECRET_KEY" == "" ]; then
  echo "NAME must be set"
  exit 1
fi

tf() {
    terraform -chdir=terraform/ivanti-lke "$@"
}

tf init -reconfigure -backend-config="access_key=$IVANTI_STATE_S3_ACCESS" -backend-config="secret_key=$IVANTI_STATE_S3_SECRET_KEY"

tf workspace select $NAME || tf workspace new $NAME

echo "Workspace $NAME"