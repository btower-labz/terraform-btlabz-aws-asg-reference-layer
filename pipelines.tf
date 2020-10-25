module "codebuild" {
  source = "git::https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asg-codebuild-module.git?ref=master"
  #source = "../../modules/terraform-aws-btlabz-arch-ref-asg-codebuild-module"
  subnets = [
    module.vpc.private_a,
    module.vpc.private_b
  ]

  git_repo = "https://github.com/btower-labz/django-dashboard-black.git"
  git_ref  = "feature/decoupling"

  buildspec_path = "buildspec/migrations.yml"

  database_secret_arn = module.database.rds_secret_arn
  tags = merge(
    map(
      "Terraform", "yes"
    ),
    var.tags
  )
}

module "codedeploy" {
  source = "git::https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-asg-codedeploy-module.git?ref=master"
  #source = "../../modules/terraform-aws-btlabz-arch-ref-asg-codedeploy-module"
  tags = merge(
    map(
      "Terraform", "yes"
    ),
    var.tags
  )
}

resource "random_id" "codedeploy" {
  byte_length = 8
}

locals {
  codedeploy_bucket_name = format("codedeploy-%s", random_id.codedeploy.hex)
}

resource "aws_s3_bucket" "codedeploy" {
  bucket = local.codedeploy_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  # Delete with all the revisions
  force_destroy = true

  tags = merge(
    map(
      "Name", "",
      "Terraform", "yes"
    ),
    var.tags
  )
}

resource "aws_ssm_parameter" "codedeploy_name" {
  name        = "/dev/code-deploy-s3-name"
  type        = "String"
  value       = aws_s3_bucket.codedeploy.id
  description = "CodeDeploy Bucket Name"
  tier        = "Standard"
  overwrite   = true
  data_type   = "text"
  tags = merge(
    map(
      "Name", "code-deploy-s3-name"
    ),
    var.tags
  )
}

resource "aws_ssm_parameter" "codedeploy_arn" {
  name        = "/dev/code-deploy-s3-arn"
  type        = "String"
  value       = aws_s3_bucket.codedeploy.arn
  description = "CodeDeploy Bucket ARN"
  tier        = "Standard"
  overwrite   = true
  data_type   = "text"
  tags = merge(
    map(
      "Name", "code-deploy-s3-arn"
    ),
    var.tags
  )
}

resource "aws_ssm_parameter" "codedeploy_app" {
  name        = "/dev/code-deploy-app-name"
  type        = "String"
  value       = module.codedeploy.app_name
  description = "CodeDeploy Application Name"
  tier        = "Standard"
  overwrite   = true
  data_type   = "text"
  tags = merge(
    map(
      "Name", "code-deploy-app-name"
    ),
    var.tags
  )
}
