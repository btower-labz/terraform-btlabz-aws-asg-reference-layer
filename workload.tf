module "workload_foo" {
  #source = "git::https://github.com/btower-labz/terraform-aws-btlabz-arch-ref-ec2-workload-module.git?ref=master"
  source = "../../modules/terraform-aws-btlabz-arch-ref-asg-workload-module"
  name   = "workload-foo"
  subnets = [
    module.vpc.private_a,
    module.vpc.private_b
  ]
  ami = var.ami

  workload_ingress_sgs = [module.balancer.balancer_sg]

  #zone_id              = module.subzone.zone_id

  lb_listener_arn = module.balancer.https_listener_arn

  wl_port  = 85
  wl_paths = ["*", "/", "/*"]
  ht_port  = 85
  ht_path  = "/status/?format=json"

  # TODO: Multiple host headers
  hostnames = [
    format("dashboard.%s", data.aws_route53_zone.subzone.name)
  ]

  database_secret_arn = module.database.rds_secret_arn

  tags = merge(
    map(
      "Workload", "workload-foo"
    ),
    var.tags
  )

}
