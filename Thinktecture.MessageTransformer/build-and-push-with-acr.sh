ACR_NAME=ttkedasample$RANDOM
AKS_NAME=ttkedaaks
RG_NAME=thinktecture-keda-sample

az acr login -n $ACR_NAME

az acr build -t $ACR_NAME.azurecr.io/message-transformer:0.0.1 -t $ACR_NAME.azurecr.io/message-transformer:latest -r $ACR_NAME .
echo
echo "DONE"
