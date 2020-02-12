#!/bin/bash

ACR_NAME=ttkedasample
RG_NAME=thinktecture-keda-sample
LOCATION=westeurope
SBN_NAME=sbn-thinktecture-keda
INBOUND_LISTEN_RULE=inbound-listener
INBOUND_SEND_RULE=inbound-send
OUTBOUND_SEND_RULE=outbound-send

# Create Authorization Rule for Azure ServiceBus Queue
az servicebus queue authorization-rule create --namespace-name $SBN_NAME -g $RG_NAME --queue-name inbound --rights Listen -n $INBOUND_LISTEN_RULE
az servicebus queue authorization-rule create --namespace-name $SBN_NAME -g $RG_NAME --queue-name inbound --rights Send -n $INBOUND_SEND_RULE
az servicebus queue authorization-rule create --namespace-name $SBN_NAME -g $RG_NAME --queue-name outbound --rights Send -n $OUTBOUND_SEND_RULE

# Retrieve and store connection string in QUEUE_LISTENER_CS
INBOUND_LISTEN_CS=$(az servicebus queue authorization-rule keys list -g $RG_NAME --namespace-name $SBN_NAME --queue-name inbound -n $INBOUND_LISTEN_RULE --query "primaryConnectionString" -o tsv)
INBOUND_SEND_CS=$(az servicebus queue authorization-rule keys list -g $RG_NAME --namespace-name $SBN_NAME --queue-name inbound -n $INBOUND_SEND_RULE --query "primaryConnectionString" -o tsv)
OUTBOUND_SEND_CS=$(az servicebus queue authorization-rule keys list -g $RG_NAME --namespace-name $SBN_NAME --queue-name outbound -n $OUTBOUND_SEND_RULE --query "primaryConnectionString" -o tsv)

# you can print the connection string using
echo 'Connection String for listening to inbound queue:'
echo $INBOUND_LISTEN_CS
echo 'Connection String for sending msgs to inbound queue:'
echo $INBOUND_SEND_CS
echo 'Connection String for sending msgs to outbound queue:'
echo $OUTBOUND_SEND_CS
