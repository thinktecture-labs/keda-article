#!/bin/bash

echo "creating keda namespace in kubernetes"
kubectl create namespace keda
echo
echo 'Installing KEDA using Helm 3'

helm install keda kedacore/keda --namespace keda
echo
echo 'DONE'
