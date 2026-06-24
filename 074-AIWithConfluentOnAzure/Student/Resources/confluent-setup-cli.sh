#!/bin/bash

# Authenticate with Confluent Cloud CLI
# https://docs.confluent.io/cloud/current/cli/install.html
# Ensure you have the Confluent CLI installed and configured
confluent login

confluent environment use "${CONFLUENT_ENVIRONMENT_ID}"

# Ensure the Cluster Region matches the Azure Region
confluent kafka cluster use "${KAFKA_ID}"

# Ensure the Flink Compute Pool Region matches the Azure Region
confluent flink compute-pool use "${FLINK_COMPUTE_POOL_ID}"

confluent api-key store --force "${CONFLUENT_CLOUD_API_KEY}" "${CONFLUENT_CLOUD_API_SECRET}"
confluent api-key store --force "${KAFKA_API_KEY}" "${KAFKA_API_SECRET}"

confluent api-key use "${KAFKA_API_KEY}"
