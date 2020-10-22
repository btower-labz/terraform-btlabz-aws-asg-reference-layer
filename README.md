# AWS ASG Reference Architecture

## Main Terraform Layer

### Project structure

See here: [FILES](FILES.md)

### Inputs\Outputs

See here: [INPUTS\OUTPUTS](INOUT.md)

### Features

* VPC deployment
* Public and Private subnets
* Public Loadbalancer with Certificates
* Sample ASG workload

### Usage

Do parent R53 zone configuration based on [private.auto.tfvars.sample](private.auto.tfvars.sample).

Configure terraform backend profile based on [backend.tf.sample](backend.tf.sample)

Configure AWS profile for the infrastructure (see [provider.tf](provider.tf))

Deploy POC using [deploy.sh](deploy.sh)

Update POC using [update.sh](update.sh)

### Module references

| Name | Repository | Notes |
| --- | --- | --- |
