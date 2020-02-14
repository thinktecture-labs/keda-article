#!/bin/bash


AKS_NAME=ttkedaaks
RG_NAME=thinktecture-keda-sample
LOCATION=westeurope
echo -n "Provide ACR name (without .azurecr.io): "
read ACR_NAME
echo -n "Provide ServicePrincipal ID: "
read SP_APP_ID
echo -n "Provide ServicePrincipal Password: "
read  -s SP_APP_PASSWD
echo
ACR_ID=$(az acr show -n $ACR_NAME --query "id" -o tsv)
echo "Creating Role Assignment for ACR"
az role assignment create --assignee $SP_APP_ID --scope $ACR_ID --role acrpull
echo
echo 'Creating Azure Kubernetes Service' $AKS_NAME
az aks create -n $AKS_NAME -g $RG_NAME -l $LOCATION --node-count 1 --service-principal $SP_APP_ID --client-secret $SP_APP_PASSWD --generate-ssh-keys
echo
echo 'Attaching ACR to AKS'
az aks update -n $AKS_NAME -g $RG_NAME --attach-acr $ACR_ID
echo
echo 'Downloading AKS credentials'
az aks get-credentials -n $AKS_NAME -g $RG_NAME
echo
echo 'Switching kubectl context to' $AKS_NAME
kubectl config set-context $AKS_NAME
echo
echo 'DONE'
