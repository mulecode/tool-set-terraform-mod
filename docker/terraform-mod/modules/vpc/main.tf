provider "aws" {
  region = var.region
}

data "aws_availability_zones" "this" {
  state = "available"
}

locals {
  # Establish AZ count from the first set's length
  first_set = keys(var.subnet_sets)[0]
  az_count  = length(var.subnet_sets[local.first_set])
  azs       = slice(data.aws_availability_zones.this.names, 0, local.az_count)

  # Build per-set, per-AZ map we can iterate over
  set_maps = {
    for set_name, cidrs in var.subnet_sets :
    set_name => { for i, az in local.azs : i => { set = set_name, az = az, cidr = cidrs[i] } }
  }

  # Derived booleans
  sets_requiring_nat = [for k, v in var.set_attributes : k if v.egress_via == "nat"]
  nat_required       = length(local.sets_requiring_nat) > 0
  igw_sets           = [for k, v in var.set_attributes : k if v.egress_via == "igw"]
}

# ----------------- VPC -----------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      Name = "${var.prefix}-${var.name}-vpc"
    },
    var.tags
  )
}

# ----------------- IGW -----------------
resource "aws_internet_gateway" "igw" {
  count  = (length(local.igw_sets) > 0 || local.nat_required) ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      Name = "${var.prefix}-${var.name}-igw"
    },
    var.tags
  )
}

# ----------------- Subnets -----------------
resource "aws_subnet" "set" {
  for_each = merge([
    for set_name, idxmap in local.set_maps :
    { for idx, x in idxmap : "${set_name}:${idx}" => x }
  ]...)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = lookup(var.set_attributes[each.value.set], "map_public_ip_on_launch", false)

  tags = merge(
    {
      Name      = "${var.prefix}-${var.name}-${each.value.set}-${each.value.az}"
      Set       = each.value.set
      AZ        = each.value.az
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

# ----------------- NAT (per-AZ in nat_host_set) -----------------
resource "aws_eip" "nat" {
  for_each = (var.nat_host_set != null && local.nat_required) ? { for k, v in aws_subnet.set : k => v if split(":", k)[0] == var.nat_host_set } : {}

  domain = "vpc"
  tags = merge(
    {
      Name = "${var.prefix}-${var.name}-eip-${aws_subnet.set[each.key].availability_zone}"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "nat" {
  for_each = (var.nat_host_set != null && local.nat_required) ? { for k, v in aws_subnet.set : k => v if split(":", k)[0] == var.nat_host_set } : {}

  allocation_id     = aws_eip.nat[each.key].id
  subnet_id         = aws_subnet.set[each.key].id
  connectivity_type = "public"
  depends_on        = [aws_internet_gateway.igw]
  tags = merge(
    {
      Name = "${var.prefix}-${var.name}-nat-${aws_subnet.set[each.key].availability_zone}"
    },
    var.tags
  )
}

# ----------------- Route tables per-subnet -----------------
resource "aws_route_table" "set" {
  for_each = { for k, s in aws_subnet.set : k => s }
  vpc_id   = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.prefix}-${var.name}-rtb-${split(":", each.key)[0]}-${each.value.availability_zone}"
      Set  = split(":", each.key)[0]
    },
    var.tags
  )
}

# Default route to IGW or NAT based on policy
resource "aws_route" "default" {
  for_each = {
    for k, s in aws_subnet.set :
    k => s
    if(
      var.set_attributes[split(":", k)[0]].egress_via == "igw" ||
      var.set_attributes[split(":", k)[0]].egress_via == "nat"
    )
  }

  route_table_id         = aws_route_table.set[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id     = var.set_attributes[split(":", each.key)[0]].egress_via == "igw" ? one(aws_internet_gateway.igw[*].id) : null
  nat_gateway_id = var.set_attributes[split(":", each.key)[0]].egress_via == "nat" ? aws_nat_gateway.nat["${var.nat_host_set}:${index(local.azs, each.value.availability_zone)}"].id : null

  depends_on = [aws_internet_gateway.igw, aws_nat_gateway.nat]
}

resource "aws_route_table_association" "set" {
  for_each       = { for k, s in aws_subnet.set : k => s }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.set[each.key].id
}
