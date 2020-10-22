module "vpc" {
  #source  = "btower-labz/btlabz-vpc-ha-2x/aws"
  source = "../../modules/terraform-aws-btlabz-pub2x-pri2x-dbs2x"
  #version = "0.1.0"
  tags = var.tags
}
