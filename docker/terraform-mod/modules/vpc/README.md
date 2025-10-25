# VPC Module

A flexible Terraform module for creating AWS VPCs with configurable subnet sets, routing strategies, and NAT gateways.

## Features

- ✅ **Flexible Subnet Configuration**: Define multiple subnet sets (public, private, isolated) with custom CIDR blocks
- ✅ **Per-AZ NAT Gateways**: Automatic NAT gateway deployment across availability zones for high availability
- ✅ **Dynamic Routing**: Configure egress routing per subnet set (Internet Gateway, NAT Gateway, or isolated)
- ✅ **Multi-AZ Support**: Automatically distributes subnets across specified availability zones
- ✅ **Comprehensive Outputs**: Access VPC, subnet, NAT gateway, and route table information easily

## Architecture

This module creates:
- **VPC** with DNS support and hostnames enabled
- **Internet Gateway** (if any subnet set requires it)
- **Subnets** distributed across availability zones based on your configuration
- **NAT Gateways** (one per AZ) in public subnets if private subnets need internet access
- **Route Tables** with appropriate routes based on egress strategy
- **Elastic IPs** for NAT Gateways

## Usage

### Basic Example - Public and Private Subnets

```hcl
module "vpc" {
  source = "./modules/vpc"

  prefix   = "myapp"
  name     = "production"
  region   = "us-east-1"
  vpc_cidr = "10.0.0.0/16"

  # Define subnet sets with CIDR blocks for each AZ
  subnet_sets = {
    public  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    private = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  }

  # Configure routing behavior for each set
  set_attributes = {
    public = {
      egress_via              = "igw"  # Route to Internet Gateway
      map_public_ip_on_launch = true
    }
    private = {
      egress_via              = "nat"  # Route to NAT Gateway
      map_public_ip_on_launch = false
    }
  }

  # NAT gateways will be placed in the public subnet set
  nat_host_set = "public"
}
```

### Advanced Example - Multiple Subnet Tiers

```hcl
module "vpc" {
  source = "./modules/vpc"

  prefix   = "mycompany"
  name     = "staging"
  region   = "us-west-2"
  vpc_cidr = "172.16.0.0/16"

  # Define multiple subnet tiers across 2 AZs
  subnet_sets = {
    public    = ["172.16.1.0/24", "172.16.2.0/24"]
    private   = ["172.16.11.0/24", "172.16.12.0/24"]
    database  = ["172.16.21.0/24", "172.16.22.0/24"]
    isolated  = ["172.16.31.0/24", "172.16.32.0/24"]
  }

  set_attributes = {
    public = {
      egress_via              = "igw"   # Direct internet access
      map_public_ip_on_launch = true
    }
    private = {
      egress_via              = "nat"   # Internet via NAT
      map_public_ip_on_launch = false
    }
    database = {
      egress_via              = "nat"   # Internet via NAT for updates
      map_public_ip_on_launch = false
    }
    isolated = {
      egress_via              = "none"  # No internet access
      map_public_ip_on_launch = false
    }
  }

  nat_host_set = "public"
}
```

### Minimal Example - Public Subnets Only

```hcl
module "vpc" {
  source = "./modules/vpc"

  prefix   = "dev"
  name     = "test"
  region   = "eu-west-1"
  vpc_cidr = "10.1.0.0/16"

  subnet_sets = {
    public = ["10.1.1.0/24", "10.1.2.0/24"]
  }

  set_attributes = {
    public = {
      egress_via              = "igw"
      map_public_ip_on_launch = true
    }
  }

  # No NAT gateway needed
  nat_host_set = null
}
```

## Input Variables

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| `prefix` | Prefix for resource naming | `string` | Yes | - |
| `name` | Unique name for the VPC | `string` | Yes | - |
| `region` | AWS region to deploy into | `string` | Yes | - |
| `vpc_cidr` | CIDR block for the VPC | `string` | Yes | - |
| `subnet_sets` | Map of subnet set names to CIDR lists (one per AZ) | `map(list(string))` | Yes | - |
| `set_attributes` | Routing and behavior configuration per subnet set | `map(object)` | Yes | - |
| `nat_host_set` | Subnet set name to host NAT gateways (must use `egress_via = "igw"`) | `string` | No | `null` |

### `set_attributes` Object Structure

```hcl
{
  egress_via              = string  # "igw", "nat", or "none"
  map_public_ip_on_launch = bool    # true or false
}
```

### Egress Via Options

- **`igw`**: Routes to Internet Gateway (public subnets)
- **`nat`**: Routes to NAT Gateway (private subnets with internet access)
- **`none`**: No internet route (isolated subnets)

## Outputs

### VPC Outputs
- `vpc_id` - The VPC ID
- `vpc_cidr` - The VPC CIDR block
- `vpc_arn` - The VPC ARN
- `internet_gateway_id` - Internet Gateway ID (if created)
- `availability_zones` - List of AZs used

### Subnet Outputs
- `subnet_ids` - Map of all subnet IDs (key: `"set_name:az_index"`)
- `subnet_ids_by_set` - Subnet IDs grouped by set name
- `subnet_arns` - Map of subnet ARNs
- `subnet_cidr_blocks` - Map of subnet CIDR blocks
- `public_subnet_ids` - List of public subnet IDs
- `private_subnet_ids` - List of private subnet IDs
- `nat_subnet_ids` - List of NAT-routed subnet IDs
- `isolated_subnet_ids` - List of isolated subnet IDs

### NAT Gateway Outputs
- `nat_gateway_ids` - Map of NAT Gateway IDs
- `nat_gateway_public_ips` - Map of NAT Gateway public IPs

### Route Table Outputs
- `route_table_ids` - Map of route table IDs
- `route_table_ids_by_set` - Route tables grouped by set name

### Comprehensive Output
- `subnet_sets` - Complete subnet information organized by set

## Output Usage Examples

### Referencing Outputs in Other Resources

```hcl
# Use specific subnet set for EC2 instances
resource "aws_instance" "app" {
  subnet_id = module.vpc.subnet_ids_by_set["private"][0]
  # ... other configuration
}

# Use public subnets for load balancer
resource "aws_lb" "public" {
  subnets = module.vpc.public_subnet_ids
  # ... other configuration
}

# Use database subnets for RDS subnet group
resource "aws_db_subnet_group" "main" {
  subnet_ids = module.vpc.subnet_ids_by_set["database"]
  # ... other configuration
}

# Reference VPC ID for security groups
resource "aws_security_group" "app" {
  vpc_id = module.vpc.vpc_id
  # ... other configuration
}

# Get NAT Gateway IPs for whitelisting
output "nat_ips_for_whitelist" {
  value = values(module.vpc.nat_gateway_public_ips)
}
```

## Important Notes

### Subnet Set Validation

All subnet sets must have the same number of CIDR blocks (one per availability zone):

```hcl
# ✅ CORRECT - All sets have 3 CIDRs
subnet_sets = {
  public  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

# ❌ INCORRECT - Mismatched lengths
subnet_sets = {
  public  = ["10.0.1.0/24", "10.0.2.0/24"]
  private = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}
```

### NAT Gateway Requirements

If any subnet set uses `egress_via = "nat"`, you must:
1. Set the `nat_host_set` variable
2. The specified set must have `egress_via = "igw"`

```hcl
# ✅ CORRECT
set_attributes = {
  public  = { egress_via = "igw", map_public_ip_on_launch = true }
  private = { egress_via = "nat", map_public_ip_on_launch = false }
}
nat_host_set = "public"  # Must be an IGW set

# ❌ INCORRECT - nat_host_set points to non-IGW set
nat_host_set = "private"
```

### Cost Considerations

- **NAT Gateways**: This module creates one NAT Gateway per availability zone in the `nat_host_set`
- Each NAT Gateway costs ~$0.045/hour + data transfer charges
- For 3 AZs: ~$97/month in NAT Gateway charges alone (excluding data transfer)
- Consider using a single NAT Gateway for non-production environments to reduce costs

## Resource Naming Convention

Resources are named using the pattern: `{prefix}-{name}-{resource-type}-{details}`

Examples:
- VPC: `myapp-production-vpc`
- Subnet: `myapp-production-public-us-east-1a`
- NAT Gateway: `myapp-production-nat-us-east-1a`
- Route Table: `myapp-production-rtb-private-us-east-1b`

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## License

This module is provided as-is for use in your infrastructure.

## Authors

Infrastructure Team

## Contributing

When contributing to this module, please ensure:
1. All variables have descriptions
2. Outputs are well documented
3. Examples are tested and working
4. Code follows Terraform best practices

