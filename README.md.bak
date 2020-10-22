# AWS EC2 Reference Architecture

## Main Terraform Layer

### Project structure

See here: [FILES](FILES.md)

### Inputs\Outputs

See here: [INPUTS\OUTPUTS](INOUT.md)

### Features

* VPC deployment
* Public and Private subnets
* Loadbalancer with Certificates
* Sample plain EC2 workload

### Usage

Do parent R53 zone configuration based on [private.auto.tfvars.sample](private.auto.tfvars.sample).

Configure terraform backend profile based on [backend.tf.sample](backend.tf.sample)

Configure AWS profile for the infrastructure (see [provider.tf](provider.tf))

Deploy POC using [deploy.sh](deploy.sh)

Update POC using [update.sh](update.sh)

Reset CodeDeploy application and clean revisions using [resetapp.sh](resetapp.sh)

### Module references

| Name | Repository | Notes |
| --- | --- | --- |
| appserver | [GIT][appserver] [TR][appserver-tr] | Application server, userdata, EC2 recovery etc |
| balancer | [GIT][balancer] [TR][balancer-tr] | Load balancer, certificates etc |
| codedeploy | [GIT][codedeploy] [TR][codedeploy-tr] | Code deploy pipelines for dev |
| subzone | [GIT][subzone] [TR][subzone-tr] | Internal zone configurations |
| workload | [GIT][workload] [TR][workload-tr] | arget groups, listener rules, aliases etc |
| vpc-ha-2x | [GIT][vpc-ha-2x] [TR][vpc-ha-2x-tr] | VPC, subnets, routing |

[appserver]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-appserver-module
[balancer]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-balancer-module
[codedeploy]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-codedeploy-module
[subzone]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-subzone-module
[workload]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-workload-module
[vpc-ha-2x]: https://github.com/btower-labz/terraform-aws-btlabz-vpc-ha-2x

[appserver-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-appserver-module/aws
[balancer-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-balancer-module/aws
[codedeploy-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-codedeploy-module/aws
[subzone-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-subzone-module/aws
[workload-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-workload-module/aws
[vpc-ha-2x-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-vpc-ha-2x/aws
