#data "aws_route53_zone" "parent" {
#  zone_id = var.parent_zone_id
#}

data "aws_route53_zone" "subzone" {
  zone_id = module.subzone.zone_id
}

module "subzone" {
  #source         = "git::https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-subzone-module.git?ref=master"
  source = "../../modules/terraform-aws-btlabz-arch-ref-ec2-subzone-module"
  name   = "asg"
  #parent_zone_id = data.aws_route53_zone.parent.zone_id
  parent_zone_id = var.parent_zone_id
  tags           = var.tags
}

