#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

aws sts get-caller-identity --profile terraform-state
aws sts get-caller-identity --profile terraform-infra

# Pipelines
terraform apply -parallelism=50 -auto-approve -target module.codebuild

terraform apply -parallelism=50 -auto-approve -target module.codedeploy

# Required parameters
terraform apply -parallelism=50 -auto-approve \
--target aws_ssm_parameter.database_host \
--target aws_ssm_parameter.database_port \
--target aws_ssm_parameter.database_name \
--target aws_ssm_parameter.database_secret_name \
--target aws_ssm_parameter.database_secret_arn \
--target random_password.django_secret \
--target aws_ssm_parameter.django_secret
