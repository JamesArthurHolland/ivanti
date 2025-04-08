#!/bin/bash

SCRIPT_DIR=$(dirname $0)#
. ./script/tf_init.sh

echo "#--------------------------------------------------"
echo "# Delete helm charts"
echo "#--------------------------------------------------"

helm delete wordpress
helm delete mariadb

echo "#--------------------------------------------------"
echo "# Teardown cluster"
echo "#--------------------------------------------------"

tf workspace select $NAME || tf workspace new $NAME

tf destroy -auto-approve \
  -var="name=$NAME" \
  -var="label=${NAME_HYPHEN}ivanti-lke-cluster"