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

# Features

* Load Balancing
* ASG (Resiliency, Scaling)
* AMI (System->MW->APP)
* RDS Backend
* Workload network and SG isolation (pub-pri-db)
* Session manager shell access
* Secrets manager and parameter store


# Deploy

codebuild manual action (allow update policy)

11:35

~5m network.sh

config packer ...

=> skip, provide branch ready image.

1. packer-system ~10 minutes
2. packer-middleware ~ 10 minutes
3. packer-application ~10 minutes

config ami setting

~10m deploy.sh

~20m 11:54 warm start

certificate validation\revalidation up to 30 minutes

# TODO

* Migrations
* Automatic AWS refresh on LT update
* Static files on CDN
* RDS Password Rotation
* Persistent storage on EFS backend
* Redis Sessions Backend
* MemCached Cache backend
* Secrets Rotation for RDS Aurora (+ASG refresh)
* Automatic scaling based on CPU
