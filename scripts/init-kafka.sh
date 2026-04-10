#!/bin/bash
set -euo pipefail

BOOTSTRAP_SERVER="kafka:9092"

topics=(
  early-settlement
  provider-settlement
  provider-settlement-parsing
  provider-settlement-v4-reupload
  direct-settlement
  provider-reconciliation
  settlement-details-create
  settlement-details-delete
  settlement-details-create-deadletter
  merchant-settlement
  merchant-settlement-v2
  settlement-topup
  master-merchant-settlement
  disbursement-batch-item-create
  disbursement-batch-item-delete
  cb-settlement-details-create
  cb-settlement-details-delete
  cb-provider-settlement
  provider-settlement-payment-batch
  provider-settlement-payment-batch-deadletter
  provider-settlement-processing-batch
  provider-settlement-processing-batch-deadletter
  settlement-transfer-callback
  settlement-transfer-deadletter
  internal-fund-callback
  internal-fund-callback-deadletter
  webhook-events
  email
)

for topic in "${topics[@]}"; do
  kafka-topics --bootstrap-server "$BOOTSTRAP_SERVER" --create --if-not-exists --topic "$topic" --partitions 1 --replication-factor 1
done

echo "Kafka topics initialized."
