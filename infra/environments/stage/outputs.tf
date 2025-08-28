output "nlb_dns_name" {
  value = module.nlb.lb_dns_name
}
output "nlb_arn" {
  value = module.nlb.lb_arn
}
output "nlb_tg_arn" {
  value = module.nlb.tg_arn
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}
output "ecr_repository_names" {

  value = module.ecr.repository_names
}
