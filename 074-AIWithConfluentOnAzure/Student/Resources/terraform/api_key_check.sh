#!/bin/bash

API_KEY="GXBNXDHDJ3PQK2ZT"
API_SECRET="GApDfNmd09jMAFzdwedbUZWI3FNM6aOTWe95H0gkN1bXpJuEYsin2hs09jTZne9u"

# export KAFKA_CLUSTER_ID="lkc-vvwyq0"
# export KAFKA_API_KEY="GXBNXDHDJ3PQK2ZT"
# export KAFKA_API_SECRET="GApDfNmd09jMAFzdwedbUZWI3FNM6aOTWe95H0gkN1bXpJuEYsin2hs09jTZne9u"

curl -u "${API_KEY}:${API_SECRET}" \
  https://api.confluent.cloud/connect/v1/environments
