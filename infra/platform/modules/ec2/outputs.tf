output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.idlms_ec2.id
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.idlms_ec2.private_ip
}

output "public_ip" {
  description = "Public IP address (if any)"
  value       = aws_instance.idlms_ec2.associate_public_ip_address
}
