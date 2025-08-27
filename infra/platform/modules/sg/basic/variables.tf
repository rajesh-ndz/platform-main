variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  description = "List of ingress rules: [{from_port, to_port, protocol, cidr_blocks}]"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "tags" {
  type    = map(string)
  default = {}
}
