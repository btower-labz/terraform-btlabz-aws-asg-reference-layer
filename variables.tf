variable "ami" {
  description = "AMI to use with workloads"
  type        = string
}

variable "tags" {
  description = "Additional tags. E.g. environment, backup tags etc"
  type        = map
  default     = {}
}

variable "parent_zone_id" {
  description = "Parent R53 zone to created additional subzones"
}
