output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = [for s in aws_subnet.public : s.id] }
output "private_subnet_ids" { value = [for s in aws_subnet.private : s.id] }
output "internet_gateway_id" { value = aws_internet_gateway.this.id }
output "nat_gateway_ids" { value = [for n in aws_nat_gateway.this : n.id] }
output "public_route_table_id" { value = aws_route_table.public.id }
# If nat_gateway_mode == "one_per_az" there are multiple private RTs, else single.
output "private_route_table_ids" { value = try([for rt in aws_route_table.private : rt.id], [aws_route_table.private_single[0].id]) }
