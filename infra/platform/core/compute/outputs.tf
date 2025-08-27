output "security_group_id" {
  value = module.sg_app.security_group_id
}
output "instance_id" {
  value = module.ec2.instance_id
}
output "instance_private_ip" {
  value = module.ec2.private_ip
}
output "instance_profile_name" {
  value = module.iam.instance_profile_name
}
