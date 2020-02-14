#!/bin/bash
RG_NAME=thinktecture-keda-sample
SBN_NAME=sbn-thinktecture-keda
AZFN_TRIGGER_RULE="azfn-trigger"
AZFN_BINDING_RULE="azfn-binding"
KEDA_SCALER_RULE="keda-scaler"
PUBLISHER_RULE="publisher-app"
echo 'Creating Kubernetes Namespace'
kubectl create namespace tt
echo
# grab connection string from Azure Service Bus
KEDA_SCALER_CONNECTION_STRING=$(az servicebus queue authorization-rule keys list \
  -g $RG_NAME \
  --namespace-name $SBN_NAME \
  --queue-name inbound \
  -n $KEDA_SCALER_RULE \
  --query "primaryConnectionString" \
  -o tsv)

echo 'Creating Kubernetes Secret for KEDA Scaler:'
# create the kubernetes secret
kubectl create secret generic tt-keda-auth \
  --from-literal KedaScaler=$KEDA_SCALER_CONNECTION_STRING \
  --namespace tt

echo 'Creating Kubernetes Secret for Azure Functions:'
AZFN_TRIGGER_CONNECTION_STRING=$(az servicebus queue authorization-rule keys list \
  -g $RG_NAME \
  --namespace-name $SBN_NAME \
  --queue-name inbound \
  -n $AZFN_TRIGGER_RULE \
  --query "primaryConnectionString" \
  -o tsv)

AZFN_OUTPUT_BINDING_CONNECTION_STRING=$(az servicebus queue authorization-rule keys list \
  -g $RG_NAME \
  --namespace-name $SBN_NAME \
  --queue-name outbound \
  -n $AZFN_BINDING_RULE \
  --query "primaryConnectionString" \
  -o tsv)

# create the secret
kubectl create secret generic tt-func-auth \
  --from-literal InboundQueue=${AZFN_TRIGGER_CONNECTION_STRING%EntityPath*} \
  --from-literal OutboundQueue=${AZFN_OUTPUT_BINDING_CONNECTION_STRING%EntityPath*} \
  --namespace tt

echo
echo 'DONE'
