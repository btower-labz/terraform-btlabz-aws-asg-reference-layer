# AWS ASG Reference Architecture

This is a reference architecture for a sample python app with enabled HA and resiliency, autoscaling and database backend.

This is the index page for the solution.
Additional information might be available inside module repositories.

This architecture is a fully functional MVP.
And there is always enough space to improve. See TODO list in the end and marks across the code.

## Features

This reference architecture deploys options as follows:

**Table:** architecture features
| Option | Reference | Notes |
| --- | --- | --- |
| HA and Resilient VPC | [usage](network.tf)<br>[module][vpc-ha-2x] | VPC is deployed in two aviability zoned, with public, private and database subnets in the each zone. Private networks are NATed, database networks are isolated.|
| Load Balancing with automatic SSL provisioning | [usage](balancer.tf)<br>[module][balancer] | Public load balancer is deployed, certificates are automatically provisioned. HTTPS is enabled. |
| ASG (Resiliency, Scaling) | [usage](workload.tf)<br>[module][workload] | Resilient ASG workload with automatic health checks is configured. |
| AMI Layering (System->MW->APP) | [system][pkr-system]<br>[middleware][pkr-middleware]<br>[application][pkr-application] | AMI prebaking is used to speed-up scaling. There are three layers: system, middleware, application. |
| HA and resilient RDS Backend with Query access | [usage](database.tf)<br>[module][database] | Aurora serverless is used as database backend. Data API with adhoc queries is enabled. |
| Workload network and SG isolation (pub-pri-db) | | Workloads are isolated with networks and security groups. E.g. only load balancer is accessible from public. ASG instances use NAT for egress and accessible only through LB. Database backend is isolated in completely internal network. Security groups are used to enforce environment isolation fuarther. E.g. LB can access ASG instances only and can't access database. Database is accessible by ASG instances only. |
| Session manager shell access and SM enabled | | |
| Secrets manager and parameter store provisioning |  [provision](ssm-config.tf) | All the instances are enabled for SSM. Environment configuration is stored in SSM Parameter Store. Database secrets are in AWS Secrets Manager. No actual secrets in VCS. |
| DJANGO local and cloud profiles (SM, Secrets) | <br>[base](https://github.com/btower-labz/django-dashboard-black/blob/master/core/settings.py)<br>[local](https://github.com/btower-labz/django-dashboard-black/blob/master/core/settings_local.py)<br>[cloud](https://github.com/btower-labz/django-dashboard-black/blob/master/core/settings_cloud.py) | DJANGO is configured with two environment profiles: local and cloud. Local can be used on dev workstations. Cloud is for AWS deployment (dev, qa, prod etc) |
| DJANGO decoupled database backend | | DJANGO is configured to use Aurora Serverless as backend and session storage. |
| DJANGO migrations CodeBuild pipeline | [usage](pipelines.tf)<br>[module][codebuild] | Simple pipeline is created to handle database migrations. CodeBuild has an access to isolated RDS inside the VPC. |
| AWS Resource Tagging |  | All the resources have tags with names, worklkoad identifiers and other metadata. |

Additional information might be available inside the modules.

## Main Terraform Layer

### Project structure

See here: [FILES](FILES.md)

### Inputs\Outputs

See here: [INPUTS\OUTPUTS](INOUT.md)

## Usage

### Prerequisites

**=>** Public R53 zone is required to deploy the solution. It will create a subzone with all the records required in that parent zone.

**=>** Control workstation with: linux, git, terraform, packer, awscli

**=>** AWS Profile with name "terraform-infra" with administrative access to the AWS account for infra provisioniung.

**=>** AWS Profile with name "packer" with administrative access to the AWS account for AMI baking.

**=>** Terraform backend configuration is recommended. This solution contains 126+ objects.

**Notice:** solution is tested with Terraform v0.12.28 only. Newer versions (<0.13) should also work fine.

**Notice:** solution is tested in eu-west-1 only. Nevertheless it should work in any region with Aurora Serverless Support. See regions aviability on the [pricing](https://aws.amazon.com/rds/aurora/pricing/?nc=sn&loc=4) page.

### Deployment procedure

**Notice:** full deployment procedure takes about 1h-2h. It depends on certain AWS services response SLA (E.g. 30m for certificate validation).

**=>** Clone the layer. It's possible to pin to tags if required.

```bash
git clone https://github.com/btower-labz/terraform-btlabz-aws-asg-reference-layer.git
cd terraform-btlabz-aws-asg-reference-layer
```

**=>** Do backend configuration. In case there is no backend config, everythong will be stored in local state. See sample: [backend.tf.sample](backend.tf.sample)

**=>** Get parent public R53 zone identifier and put it in ```private.auto.tfvars```. See sample: [private.auto.tfvars.sample](private.auto.tfvars.sample)

**=>** Configure AWS profile for the infrastructure (see [provider.tf](provider.tf))
Check with ```aws sts get-caller-identity --profile terraform-infra```

**=>** Initialize backend and update terraform modules. This step will fetch all the required modules from github and terraform registry.

```bash
terraform init -upgrade=true
```

**=>** Deploy Network using [network.sh](network.sh). This will deploy VPC, subnets, routing and NATs. Notice VPC and SUBNET identifiers.

```bash
./network.sh
```

**=>** Go up, clone and and bake AMIs in order: system->middleware->application. It's required so configure ```packer-vars.sh``` for the each image. See samples in ```packer-vars.sh.sample```. It's possible to retrieve values with ```terraform output```.

**=>** Build system image as follows:

```bash
cd ..
git clone https://github.com/btower-labz/packer-aws-ec2-reference-system.git
cd packer-aws-ec2-reference-system
cp packer-vars.sh.sample packer-vars.sh
nano packer-vars.sh
...
./build-ami.sh
```

**=>** Build middleware image as follows:

```
cd ..
git clone https://github.com/btower-labz/packer-aws-asg-reference-middleware.git
cd packer-aws-asg-reference-middleware
cp packer-vars.sh.sample packer-vars.sh
nano packer-vars.sh
...
./build-ami.sh
```

**=>** Build application image as follows:

```
cd ..
git clone https://github.com/btower-labz/packer-aws-asg-reference-application.git
cd packer-aws-asg-reference-application
cp packer-vars.sh.sample packer-vars.sh
nano packer-vars.sh
...
./build-ami.sh
```

**=>** After all the images are ready, let's deploy the database and the migrations pipeline.

```bash
./database.sh
./pipelines.sh
```

**=>** Go to CodeBuild console, edit the pipeline environment. Make sure "Allow AWS CodeBuild to modify this service role so it can be used with this build project" is selected and save changes. This will add all the dynamic policies which are required for CodeBuild to run. Save changes.

**=>** Run the pipeline. Watch for phase details and the build log. This pipeline will create daatabase schema for the sample applications. Essentially it will run DJANGO migrations. Pipeline definition is here: [buildspec/migrations.yml](https://github.com/btower-labz/django-dashboard-black/blob/master/buildspec/migrations.yml).

**=>** After all it's possible to get to RDS Home -> Query Editor and review data there. Use username and password from AWS Secrets Manager secret.

**=>** When it's done, deploy the rest of infrastructure.

```
cd terraform-btlabz-aws-asg-reference-layer
./deploy.sh
```

**=>** After deployment is finished it's possible to just update everything with

```
./update.sh
```

**=>** Destroy all the infrastructure as follows:

```bash
./destroy.sh
```

### Operations

The site should be available at https://dashboard.asg.<your-public-domain>.

Status check is availabvle at this URL: https://dashboard.asg.<your-public-domain>/status/

It's possible to open SSH sessions with AWS sessions manager console. All the instances have enabled SSM agent. It's also possible to use SSM commands and documents on the workload.

It's possible to check instances healths in ASG console and Target Group console.

Rebuild the AMI and initiate ASG Instance Refresh to deploy a new software version.

ASG will automatically relaunch instances in case the app is failing health checks, or the instance is terminated manually.

### Deployment timings

AMI baking time ~10-12 minutes. So, the whole sequence is ~30 minutes long.

Certificate provisioning ~5 minutes, but can be ~30-40 minutes.

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
* [ ] Automatic ASG refresh on LT update with SNS+Lambda
* [ ] Static files on CDN
* [ ] Get rid of manual CodeBuild update (policies issue)
* [ ] RDS Password Rotation (B/G) with standard Lambda + Lambda pipeline + ASG Refresh
* [ ] DJANGO Persistent storage on EFS backend
* [ ] DJANGO Redis Sessions Backend
* [ ] DJANGO MemCached Cache backend
* [ ] Automatic scaling based on CPU
* [ ] DJANGO decouple sessions => AWS Elastic Cache (REDIS)
* [ ] DJANGO decouple cache  => AWS Elastic Cache (MEMCACHED)
* [ ] DJANGO decouple file => AWS EFS
* [ ] Refactor SSM parameters to a separate module
* [ ] Packer pipelines
* [ ] Send instance and application logs to CloudWatch Logs
* [ ] Create CodeDeploy pipeline for ad-hoc updates (non-AMI) + ASG Refresh

[balancer]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-balancer-module
[codebuild]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asg-codebuild-module
[codedeploy]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asg-codedeploy-module
[subzone]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-subzone-module
[workload]: https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asg-workload-module
[database]: https://github.com/btower-labz/terraform-aws-btlabz-aurora-serverless-module
[vpc-ha-2x]: https://github.com/btower-labz/terraform-aws-btlabz-pub2x-pri2x-dbs2x

[balancer-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-balancer-module/aws
[codebuild-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-asg-codebuild-module/aws
[codedeploy-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-codedeploy-module/aws
[subzone-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-ec2-subzone-module/aws
[workload-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-arch-ref-asg-workload-module/aws
[database-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-aurora-serverless-module/aws
[vpc-ha-2x-tr]: https://registry.terraform.io/modules/btower-labz/btlabz-pub2x-pri2x-dbs2x/aws

[pkr-system]: https://github.com/btower-labz/packer-aws-ec2-reference-system
[pkr-middleware]: https://github.com/btower-labz/packer-aws-asg-reference-middleware
[pkr-application]: https://github.com/btower-labz/packer-aws-asg-reference-application

[app-src]: https://github.com/btower-labz/django-dashboard-black
