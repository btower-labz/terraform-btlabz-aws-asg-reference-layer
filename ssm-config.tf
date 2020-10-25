variable "ssm_parameter_prefix" {
}

resource "aws_ssm_parameter" "database_host" {
  name  = format("%s/%s", var.ssm_parameter_prefix, "DATABASE_HOST")
  type  = "String"
  value = module.database.rds_endpoint
}

resource "aws_ssm_parameter" "database_port" {
  name  = format("%s/%s", var.ssm_parameter_prefix, "DATABASE_PORT")
  type  = "String"
  value = module.database.rds_port
}

resource "aws_ssm_parameter" "database_name" {
  name  = format("%s/%s", var.ssm_parameter_prefix, "DATABASE_NAME")
  type  = "String"
  value = module.database.rds_database_name
}

resource "aws_ssm_parameter" "database_secret_name" {
  name  = format("%s/%s", var.ssm_parameter_prefix, "DATABASE_SECRET_NAME")
  type  = "String"
  value = module.database.rds_secret_arn
}

resource "aws_ssm_parameter" "database_secret_arn" {
  name  = format("%s/%s", var.ssm_parameter_prefix, "DATABASE_SECRET_ARN")
  type  = "String"
  value = module.database.rds_secret_arn
}

resource "random_password" "django_secret" {
  length           = 16
  upper            = true
  min_upper        = 1
  lower            = true
  min_lower        = 1
  number           = true
  min_numeric      = 1
  special          = true
  override_special = "#_"
  min_special      = 1
}

resource "aws_ssm_parameter" "django_secret" {
  name  = format("%s/%s", var.ssm_parameter_prefix, "DJANGO_SECRET")
  type  = "SecureString"
  value = random_password.django_secret.result
}
