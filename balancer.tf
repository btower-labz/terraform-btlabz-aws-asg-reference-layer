module "balancer" {
  source = "git::https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-balancer-module.git?ref=master"
  #source = "../../modules/terraform-aws-btlabz-arch-ref-ec2-balancer-module"
  name = "balancer"
  subnets = [
    module.vpc.public_a,
    module.vpc.public_b
  ]
  zone_id = module.subzone.zone_id
  alias_list = [
    "foo",
    "bar",
    "dashboard"
  ]
  tags = var.tags
}
