#!/bin/bash

TF=$(which terraform)

external_ip="83.96.237.154"
customer_name="company_x"
customer_ip="83.96.147.9"
user_pass="$(openssl rand -hex 10)"

TF_VAR_customer_name="$customer_name" TF_VAR_customer_ip="$customer_ip" TF_VAR_user_pass="$user_pass" TF_VAR_external_ip="$external_ip" $TF apply

echo ""
echo "Deployed Insights on Demand. User password is $user_pass"
echo ""

