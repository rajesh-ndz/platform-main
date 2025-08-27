terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

locals {
  name_tags = merge(var.tags, { Environment = var.env_name })
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = merge(local.name_tags, { Name = var.vpc_name })
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.name_tags, { Name = "${var.env_name}-igw" })
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each                = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = element(var.azs, tonumber(each.key))
  map_public_ip_on_launch = true
  tags                    = merge(local.name_tags, { Name = "${var.env_name}-public-${each.key}" })
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each          = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = element(var.azs, tonumber(each.key))
  tags              = merge(local.name_tags, { Name = "${var.env_name}-private-${each.key}" })
}

# Public route table + default route to IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.name_tags, { Name = "${var.env_name}-public-rt" })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateways + EIPs (either single or one per AZ)
# Public subnet keys sorted for consistent indexing
locals {
  public_keys = [for k in sort(keys(aws_subnet.public)) : k]
}

# one NAT per selected "slot" (either 1 or N)
resource "aws_eip" "nat" {
  for_each = var.nat_gateway_mode == "one_per_az" ? toset(local.public_keys) : toset(slice(local.public_keys, 0, 1))
  domain   = "vpc"
  tags     = merge(local.name_tags, { Name = "${var.env_name}-nat-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = var.nat_gateway_mode == "one_per_az" ? toset(local.public_keys) : toset(slice(local.public_keys, 0, 1))
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = merge(local.name_tags, { Name = "${var.env_name}-nat-${each.key}" })
  depends_on    = [aws_internet_gateway.this]
}

# Private route tables + default route to NAT(s)
# If single NAT, create one private RT and associate all private subnets.
resource "aws_route_table" "private_single" {
  count  = var.nat_gateway_mode == "single" ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.name_tags, { Name = "${var.env_name}-private-rt" })
}

resource "aws_route" "private_single_default" {
  count                  = var.nat_gateway_mode == "single" ? 1 : 0
  route_table_id         = aws_route_table.private_single[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = one([for k, n in aws_nat_gateway.this : n.id])
}

resource "aws_route_table_association" "private_single_assoc" {
  for_each       = var.nat_gateway_mode == "single" ? aws_subnet.private : {}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_single[0].id
}

# If one_per_az, create one private RT per AZ and associate subnets by matching index
resource "aws_route_table" "private" {
  for_each = var.nat_gateway_mode == "one_per_az" ? aws_subnet.private : {}
  vpc_id   = aws_vpc.this.id
  tags     = merge(local.name_tags, { Name = "${var.env_name}-private-rt-${each.key}" })
}

resource "aws_route" "private_default" {
  for_each               = var.nat_gateway_mode == "one_per_az" ? aws_route_table.private : {}
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = var.nat_gateway_mode == "one_per_az" ? aws_subnet.private : {}
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
