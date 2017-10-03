#!/bin/bash

#THECMD=$0

if [[ "" == ${AZURE_CLIENT_ID} ]]; then
  echo "You need to specify a AZURE_CLIENT_ID"
  exit 1
fi

if [[ "" == ${AZURE_CLIENT_SECRET} ]]; then
  echo "You need to specify a AZURE_CLIENT_SECRET"
  exit 1
fi

if [[ "" == ${AZURE_TENANT_ID} ]]; then
  echo "You need to specify a AZURE_TENANT_ID"
  exit 1
fi

if [[ "" == ${AZURE_SUBSCRIPTION_ID} ]]; then
  echo "You need to specify a AZURE_SUBSCRIPTION_ID"
  exit 1
fi

if [[ "" == ${TIMER} ]]; then
  echo "No timer specified, default value = 60 sec"
  TIMER=60
fi

az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID >> /dev/null

dir="./metrics"
for f in "$dir"/*; do
  watch -n $TIMER $f &
done

