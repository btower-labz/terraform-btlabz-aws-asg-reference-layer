#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

aws sts get-caller-identity --profile terraform-state
aws sts get-caller-identity --profile terraform-infra

export TF_LOG=TRACE
export TF_LOG_PATH=terraform.log

rm -f terraform.log

terraform destroy
# -parallelism=50
