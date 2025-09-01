data "terraform_remote_state" "nlb" {
  backend = "s3"
  config = {
    bucket = var.nlb_tf_state_bucket
    key    = var.nlb_tf_state_key
    region = var.nlb_tf_state_region
  }
}
