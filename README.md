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

* HA and Resilient VPC
* Load Balancing with automatic SSL provisioning
* ASG (Resiliency, Scaling)
* AMI Layering (System->MW->APP)
* HA and resilient RDS Backend with Query access
* Workload network and SG isolation (pub-pri-db)
* Session manager shell access and SM enabled
* Secrets manager and parameter store provisioning
* DJANGO local and cloud profiles (SM, Secrets)
* DJANGO decoupled database backend

# Deploy
r53 public zone
terraform profiles
deploy network
packer profiles
configure and do packer
deploy database and codebuild
do migrations (do environment update once)
deploy the rest
deploy codebuild if required

~1h - 1.5h

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

* [v] Migrations pipeline
* [ ] Automatic AWS refresh on LT update
* [ ] Static files on CDN
* [ ] RDS Password Rotation
* [ ] Persistent storage on EFS backend
* [ ] Redis Sessions Backend
* [ ] MemCached Cache backend
* [ ] Secrets Rotation for RDS Aurora (+ASG refresh)
* [ ] Automatic scaling based on CPU
* [ ] DJANGO decouple sessions => AWS Elastic Cache (REDIS)
* [ ] DJANGO decouple cache  => AWS Elastic Cache (MEMCACHED)
* [ ] DJANGO decouple file => AWS EFS
