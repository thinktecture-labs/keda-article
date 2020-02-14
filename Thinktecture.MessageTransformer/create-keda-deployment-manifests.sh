#!/bin/bash

echo "Provide the ACR name (excluding .azurecr.io): "
read ACR_NAME
echo

echo "Creating KEDA deployment manifests..."
func kubernetes deploy --namespace tt \
  --name transformer-fn \
  --image-name $ACR_NAME.azurecr.io/message-transformer:0.0.1 \
  --polling-interval 5 \
  --cooldown-interval 10 \
  --min-replicas 0 \
  --max-replicas 50 \
  --secret-name tt-func-auth \
  --dry-run > keda-deployment.yaml
