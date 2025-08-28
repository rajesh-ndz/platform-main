variable "name" { type = string }                 # short logical name, e.g. "idlms-api"
variable "environment" { type = string }          # "stage" | "prod"
variable "integration_endpoint" { type = string } # e.g. "http://<NLB-DNS>:80" (no trailing slash)
variable "stage_name" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}

