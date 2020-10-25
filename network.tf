module "vpc" {
  source = "git::https://github.com/btower-labz/terraform-aws-btlabz-pub2x-pri2x-dbs2x.git?ref=v0.1.1"
  #source  = "btower-labz/btlabz-pub2x-pri2x-dbs2x/aws"
  #source = "../../modules/terraform-aws-btlabz-pub2x-pri2x-dbs2x"
  #version = "0.1.1"
  tags = var.tags
}
