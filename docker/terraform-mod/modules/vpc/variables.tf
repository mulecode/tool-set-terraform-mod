variable "prefix" {
  description = "Prefix for the Role resource"
  type        = string
}
variable "name" {
  description = "Unique name for your VPC"
  type = string
}
variable "region" {
  description = "AWS region to deploy into"
  type = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}
# Map of set_name => list of CIDRs (length per set == number of AZs you’ll use)
variable "subnet_sets" {
  description = "Generic map of subnet sets to CIDR lists."
  type = map(list(string))
}

# Map of set_name => attributes controlling routing/behaviour
# egress_via: "igw" | "nat" | "none"
variable "set_attributes" {
  description = "Behaviour per set."
  type        = map(object({
    egress_via              = string
    map_public_ip_on_launch = bool
  }))
  validation {
    condition = alltrue([
      for v in values(var.set_attributes) :
      contains(["igw", "nat", "none"], v.egress_via)
    ])
    error_message = "Each egress_via must be one of: \"igw\", \"nat\", or \"none\"."
  }
}

# Name of a set whose subnets are public and will host NAT gateways (required if any set uses nat)
variable "nat_host_set" {
  description = "Set used to place NAT gateways (must be an IGW set)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to all VPC resources"
  type        = map(string)
  default     = {}
}
