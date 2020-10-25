output "vpc_id" {
  description = "Solution VPC identifier"
  value       = module.vpc.vpc_id
}

output "public_network_id" {
  description = "Solution public network identifier"
  value       = module.vpc.public_a
}

output "codebuild_id" {
  description = "Migrations pipeline id"
  value       = module.codebuild.id
}

output "rds_secret_name" {
  description = "RDS Secret"
  value       = module.database.rds_secret_name
}
