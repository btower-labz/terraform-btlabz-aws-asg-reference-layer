# AWS ASG Reference Architecture

This is a reference architecture for a sample python app with enabled HA and resiliency, autoscaling and database backend.

## Features

This reference architecture deploys options as follows

**Table:** architecture features
| Option | Reference | Notes |
| --- | --- | --- |
| HA and Resilient VPC | [usage](network.tf)<br>[module][vpc-ha-2x] | VPC is deployed in two aviability zoned, with public, private and database subnets in the each zone. Private networks are NATed, database networks are isolated.|
| Load Balancing with automatic SSL provisioning | [usage](balancer.tf)<br>[module][balancer] | Public load balancer is deployed, certificates are automatically provisioned. HTTPS is enabled. |
| ASG (Resiliency, Scaling) | [usage](workload.tf)<br>[module][workload] | Resilient ASG workload with automatic health checks is configured. |
| AMI Layering (System->MW->APP) | [system][pkr-system]<br>[middleware][pkr-middleware]<br>[application][pkr-application] | AMI prebaking is used to speed-up scaling. There are three layers: system, middleware, application. |
| HA and resilient RDS Backend with Query access | [usage](database.tf)<br>[module][database] | Aurora serverless is used as database backend. Data API with adhoc queries is enabled. |
| Workload network and SG isolation (pub-pri-db) | | |
| Session manager shell access and SM enabled | | |
| Secrets manager and parameter store provisioning | | |
| DJANGO local and cloud profiles (SM, Secrets) | | |
| DJANGO decoupled database backend | | |
| DJANGO migrations CodeBuild pipeline | | |

## Main Terraform Layer

### Project structure

See here: [FILES](FILES.md)

### Inputs\Outputs

See here: [INPUTS\OUTPUTS](INOUT.md)

## Usage

Do parent R53 zone configuration based on [private.auto.tfvars.sample](private.auto.tfvars.sample).

Configure terraform backend profile based on [backend.tf.sample](backend.tf.sample)

Configure AWS profile for the infrastructure (see [provider.tf](provider.tf))

Deploy POC using [deploy.sh](deploy.sh)

Update POC using [update.sh](update.sh)

Terraform v0.12.28
+ provider.aws v3.5.0
+ provider.random v3.0.0
+ provider.template v2.2.0

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


### Module references

| Name | Repository | Notes |
| --- | --- | --- |
| balancer | [GIT][balancer] - [TR][balancer-tr] | Load balancer, certificates etc |
| codebuild | [GIT][codedeploy] - [TR][codebuild-tr] | Code build pipelines for dev |
| codedeploy | [GIT][codedeploy] - [TR][codedeploy-tr] | Code deploy pipelines for dev |
| subzone | [GIT][subzone] - [TR][subzone-tr] | Internal zone configurations |
| workload | [GIT][workload] - [TR][workload-tr] | ASAG, target groups, listener rules, aliases etc |
| database | [GIT][database] - [TR][database-tr] | Database backend |
| vpc-ha-2x | [GIT][vpc-ha-2x] - [TR][vpc-ha-2x-tr] | VPC, subnets, routing |

### Packer reference

| Name | Repository | Notes |
| --- | --- | --- |
| packer-aws-ec2-reference-system | [GIT][pkr-system] | Basic operating system and common agents |
| packer-aws-asg-reference-middleware | [GIT][pkr-middleware] | Application middleware |
| packer-aws-asg-reference-application | [GIT][pkr-application] | Application specific configurations and prefetch |

### Other reference

| Name | Repository | Notes |
| --- | --- | --- |
| django-dashboard-black | [GIT][app-src] | Sample python application |  

## TODO

* [x] Migrations pipeline
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


[balancer]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-balancer-module
[codebuild]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asg-codebuild-module
[codedeploy]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asf-codedeploy-module
[subzone]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-subzone-module
[workload]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asg-workload-module
[database]: https://github.com/btower-labz/terraform-aws-btlabz-aurora-serverless-module
[vpc-ha-2x]: https://github.com/btower-labz/terraform-aws-btlabz-pub2x-pri2x-dbs2x

[balancer-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-balancer-module/aws
[codebuild-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-codebuild-module/aws
[codedeploy-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-codedeploy-module/aws
[subzone-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-subzone-module/aws
[workload-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-asg-workload-module/aws
[database-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-aurora-serverless-module/aws
[vpc-ha-2x-tr]: https://registry.terraform.io/modules/btower-labz/terraform-aws-btlabz-pub2x-pri2x-dbs2x/aws

[pkr-system]: https://github.com/btower-labz/packer-aws-ec2-reference-system
[pkr-middleware]: https://github.com/btower-labz/packer-aws-asg-reference-middleware
[pkr-application]: https://github.com/btower-labz/packer-aws-asg-reference-application

[app-src]: https://github.com/btower-labz/django-dashboard-black
