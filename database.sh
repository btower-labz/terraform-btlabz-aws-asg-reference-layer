#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

#aws sts get-caller-identity --profile terraform-state
aws sts get-caller-identity --profile terraform-infra

# Database
terraform apply -parallelism=50 -auto-approve -target module.database
