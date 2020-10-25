module "database" {
  #source = "git::https://github.com/btower-labz/terraform-aws-btlabz-aurora-serverless-module.git?ref=master"
  source               = "../../modules/terraform-aws-btlabz-aurora-serverless-module"
  name                 = "database"
  database_name        = "workload"
  db_subnet_group_name = module.vpc.database_dsg_name
  database_ingress_sgs = [
    module.codebuild.codebuild_sg,
    module.workload_foo.workload_sg
  ]
  #zone_id = module.subzone.zone_id
  #alias_list = [
  #  "foo",
  #  "bar"
  #]
  tags = var.tags
}
