module "aws_vpc" {
  for_each = var.aws_vpcs
  source   = "./modules/vpc"

  # Required variables
  prefix   = var.project_prefix
  name     = each.key
  region   = var.region
  vpc_cidr = each.value.vpc_cidr

  # Subnet configuration
  subnet_sets    = each.value.subnet_sets
  set_attributes = each.value.set_attributes

  # NAT Gateway configuration
  nat_host_set = each.value.nat_host_set

  # Tags
  tags = each.value.tags
}
