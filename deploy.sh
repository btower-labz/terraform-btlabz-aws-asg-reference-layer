#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

aws sts get-caller-identity --profile terraform-state
aws sts get-caller-identity --profile terraform-infra

# Network
terraform apply -parallelism=50 -auto-approve -target module.vpc -target module.subzone

# Certificate
terraform apply -parallelism=50 -auto-approve -target module.balancer.aws_acm_certificate.balancer

# The rest of infra
terraform apply -parallelism=50 -auto-approve
