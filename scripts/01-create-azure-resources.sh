#!/bin/bash

ACR_NAME=ttkedasample$RANDOM
AKS_NAME=ttkedaaks
RG_NAME=thinktecture-keda-sample
LOCATION=westeurope
SBN_NAME=sbn-thinktecture-keda
AZFN_TRIGGER_RULE="azfn-trigger"
AZFN_BINDING_RULE="azfn-binding"
KEDA_SCALER_RULE="keda-scaler"
PUBLISHER_RULE="publisher-app"

echo 'Creating Azure Resource Group' $RG_NAME
# Create a dedicated resource group
az group create -n $RG_NAME -l $LOCATION
echo

echo 'Creating Azure Container Registry' $ACR_NAME
# Create a Azure Container Registry
az acr create -n $ACR_NAME -g $RG_NAME -l $LOCATION --sku Basic
ACR_ID=$(az acr show -n $ACR_NAME --query "id" -o tsv)
echo "ACR created with name" $ACR_NAME".azurecr.io"
echo

echo 'Creating Azure Service Bus Namespace' $SBN_NAME
# Create a ServiceBus Namespace
az servicebus namespace create -n $SBN_NAME -g $RG_NAME -l $LOCATION --sku Basic
echo
echo 'Creating Azure Service Bus Queue (inbound)'
# Create inbound Queue
az servicebus queue create -n inbound --namespace-name $SBN_NAME -g $RG_NAME
echo
echo 'Creating Azure Service Bus Queue (outbound)'
# Create outbound queue
az servicebus queue create -n outbound --namespace-name $SBN_NAME -g $RG_NAME
echo
echo 'Creating Azure Service Bus Authorization Rules'
# Create Authorization Rule for Azure ServiceBus Queue
az servicebus queue authorization-rule create --namespace-name $SBN_NAME -g $RG_NAME --queue-name inbound --rights Listen Send Manage -n $KEDA_SCALER_RULE
az servicebus queue authorization-rule create --namespace-name $SBN_NAME -g $RG_NAME --queue-name inbound --rights Listen -n $AZFN_TRIGGER_RULE
az servicebus queue authorization-rule create --namespace-name $SBN_NAME -g $RG_NAME --queue-name outbound --rights Send -n $AZFN_BINDING_RULE
az servicebus queue authorization-rule create --namespace-name $SBN_NAME -g $RG_NAME --queue-name inbound --rights Send -n $PUBLISHER_RULE
echo
echo "Generated all Authorization Rules"
# you can print the connection string using
echo 'Connection String for KEDA SCALER:'
echo $(az servicebus queue authorization-rule keys list -g $RG_NAME --namespace-name $SBN_NAME --queue-name inbound -n $KEDA_SCALER_RULE --query "primaryConnectionString" -o tsv)
echo
echo 'Connection String for Azure Functions Trigger:'
echo $(az servicebus queue authorization-rule keys list -g $RG_NAME --namespace-name $SBN_NAME --queue-name inbound -n $AZFN_TRIGGER_RULE --query "primaryConnectionString" -o tsv)
echo
echo 'Connection String for Azure Functions Output Binding:'
echo $(az servicebus queue authorization-rule keys list -g $RG_NAME --namespace-name $SBN_NAME --queue-name outbound -n $AZFN_BINDING_RULE --query "primaryConnectionString" -o tsv)
echo
echo 'Connection String for .NET Core Publisher App:'
echo $(az servicebus queue authorization-rule keys list -g $RG_NAME --namespace-name $SBN_NAME --queue-name inbound -n $PUBLISHER_RULE --query "primaryConnectionString" -o tsv)
echo
echo
echo "Part 1: Done"
echo
echo "Create a new Sercice Principal for AKS (use following command)"
echo "az ad sp create-for-rbac --skip-assignment --name thinktecture-keda-sample -o json"
echo
echo "Execute 2nd script to provision AKS"
