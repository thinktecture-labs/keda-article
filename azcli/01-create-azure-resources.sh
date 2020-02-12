#!/bin/bash

ACR_NAME=ttkedasample
RG_NAME=thinktecture-keda-sample
LOCATION=westeurope
SBN_NAME=sbn-thinktecture-keda

echo 'Creating Azure Resource Group' $RG_NAME
# Create a dedicated resource group
az group create -n $RG_NAME -l $LOCATION

echo 'Creating Azure Container Registry' $ACR_NAME
# Create a Azure Container Registry
az acr create -n $ACR_NAME -g $RG_NAME -l $LOCATION --sku Basic

echo 'Creating Azure ServiceBus Namespace' $SBN_NAME
# Create a ServiceBus Namespace
az servicebus namespace create -n $SBN_NAME -g $RG_NAME -l $LOCATION --sku Basic

echo 'Creating Azure ServiceBus Queue (inbound)'
# Create inbound Queue
az servicebus queue create -n inbound --namespace-name $SBN_NAME -g $RG_NAME

echo 'Creating Azure ServiceBus Queue (outbound)'
# Create outbound queue
az servicebus queue create -n outbound --namespace-name $SBN_NAME -g $RG_NAME
