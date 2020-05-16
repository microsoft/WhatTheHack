#!/bin/bash


sed -i "s#{subscription_id}#$subscription_id#g" vote.tf
sed -i "s#{client_id}#$client_id#g" vote.tf
sed -i "s,{client_secret},$client_secret,g" vote.tf
sed -i "s#{tenant_id}#$tenant_id#g" vote.tf

cat vote.tf

/go/bin/terraform init
sleep 5s
/go/bin/terraform apply -auto-approve
sleep 120s
/go/bin/terraform destroy -auto-approve