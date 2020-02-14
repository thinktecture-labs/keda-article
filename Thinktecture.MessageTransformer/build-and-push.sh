#!/bin/bash
ACR_NAME=ttkedasample$RANDOM

echo 'Building Docker Image'
docker build -t $ACR_NAME.azurecr.io/message-transformer:0.0.1 -t $ACR_NAME.azurecr.io/message-transformer:latest .
echo
echo 'Authenticating at ACR'
az acr login -n $ACR_NAME
echo
echo 'Pushing Docker Images to ACR'
docker push $ACR_NAME.azurecr.io/message-transformer:0.0.1
docker push $ACR_NAME.azurecr.io/message-transformer:latest
echo
echo "DONE"
