output "vpc_id" {
  description = "Solution VPC identifier"
  value       = module.vpc.vpc_id
}

output "public_network_id" {
  description = "Solution public network identifier"
  value       = module.vpc.public_a
}
