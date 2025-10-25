output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway (if created)"
  value       = length(aws_internet_gateway.igw) > 0 ? aws_internet_gateway.igw[0].id : null
}

output "availability_zones" {
  description = "List of availability zones used by the VPC"
  value       = local.azs
}

output "subnet_ids" {
  description = "Map of all subnet IDs (key format: set_name:az_index)"
  value       = { for k, v in aws_subnet.set : k => v.id }
}

output "subnet_ids_by_set" {
  description = "Map of subnet IDs grouped by set name"
  value = {
    for set_name in keys(var.subnet_sets) :
    set_name => [
      for k, v in aws_subnet.set :
      v.id if split(":", k)[0] == set_name
    ]
  }
}

output "subnet_arns" {
  description = "Map of all subnet ARNs (key format: set_name:az_index)"
  value       = { for k, v in aws_subnet.set : k => v.arn }
}

output "subnet_cidr_blocks" {
  description = "Map of all subnet CIDR blocks (key format: set_name:az_index)"
  value       = { for k, v in aws_subnet.set : k => v.cidr_block }
}

output "nat_gateway_ids" {
  description = "Map of NAT Gateway IDs (if created)"
  value       = { for k, v in aws_nat_gateway.nat : k => v.id }
}

output "nat_gateway_public_ips" {
  description = "Map of NAT Gateway public IP addresses (if created)"
  value       = { for k, v in aws_eip.nat : k => v.public_ip }
}

output "route_table_ids" {
  description = "Map of all route table IDs (key format: set_name:az_index)"
  value       = { for k, v in aws_route_table.set : k => v.id }
}

output "route_table_ids_by_set" {
  description = "Map of route table IDs grouped by set name"
  value = {
    for set_name in keys(var.subnet_sets) :
    set_name => [
      for k, v in aws_route_table.set :
      v.id if split(":", k)[0] == set_name
    ]
  }
}

output "public_subnet_ids" {
  description = "List of subnet IDs that route to IGW (public subnets)"
  value = [
    for k, v in aws_subnet.set :
    v.id if var.set_attributes[split(":", k)[0]].egress_via == "igw"
  ]
}

output "private_subnet_ids" {
  description = "List of subnet IDs that route to NAT or have no internet egress"
  value = [
    for k, v in aws_subnet.set :
    v.id if var.set_attributes[split(":", k)[0]].egress_via != "igw"
  ]
}

output "nat_subnet_ids" {
  description = "List of subnet IDs that route to NAT Gateway"
  value = [
    for k, v in aws_subnet.set :
    v.id if var.set_attributes[split(":", k)[0]].egress_via == "nat"
  ]
}

output "isolated_subnet_ids" {
  description = "List of subnet IDs with no internet egress"
  value = [
    for k, v in aws_subnet.set :
    v.id if var.set_attributes[split(":", k)[0]].egress_via == "none"
  ]
}

output "subnet_sets" {
  description = "Complete information about all subnets organized by set"
  value = {
    for set_name in keys(var.subnet_sets) :
    set_name => {
      subnet_ids = [
        for k, v in aws_subnet.set :
        v.id if split(":", k)[0] == set_name
      ]
      cidr_blocks = [
        for k, v in aws_subnet.set :
        v.cidr_block if split(":", k)[0] == set_name
      ]
      availability_zones = [
        for k, v in aws_subnet.set :
        v.availability_zone if split(":", k)[0] == set_name
      ]
      egress_via              = var.set_attributes[set_name].egress_via
      map_public_ip_on_launch = var.set_attributes[set_name].map_public_ip_on_launch
    }
  }
}

