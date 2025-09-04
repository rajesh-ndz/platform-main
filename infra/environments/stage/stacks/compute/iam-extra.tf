data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# CloudWatch Agent managed policy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = module.compute.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# ECR ReadOnly (if you pull from ECR later)
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = module.compute.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Describe helpers
data "aws_iam_policy_document" "describe" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "elasticloadbalancing:Describe*"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "describe" {
  name   = "${var.env_name}-ec2-describe"
  policy = data.aws_iam_policy_document.describe.json
}
resource "aws_iam_role_policy_attachment" "describe_attach" {
  role       = module.compute.iam_role_name
  policy_arn = aws_iam_policy.describe.arn
}

# Let CW Agent fetch config from SSM Parameter
data "aws_iam_policy_document" "ssm_get_parameter" {
  statement {
    effect  = "Allow"
    actions = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParameterHistory"]
    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${var.cloudwatch_ssm_config_path}",
    ]
  }
}
resource "aws_iam_policy" "ssm_get_parameter" {
  name   = "${var.env_name}-ssm-get-parameter"
  policy = data.aws_iam_policy_document.ssm_get_parameter.json
}
resource "aws_iam_role_policy_attachment" "ssm_get_parameter_attach" {
  role       = module.compute.iam_role_name
  policy_arn = aws_iam_policy.ssm_get_parameter.arn
}

# Allow instance to read deployment artifacts from the artifact bucket
data "aws_iam_policy_document" "artifacts_read" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.docker_artifact_bucket}"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.docker_artifact_bucket}/*"]
  }
}
resource "aws_iam_policy" "artifacts_read" {
  name   = "${var.env_name}-artifacts-read"
  policy = data.aws_iam_policy_document.artifacts_read.json
}
resource "aws_iam_role_policy_attachment" "artifacts_read_attach" {
  role       = module.compute.iam_role_name
  policy_arn = aws_iam_policy.artifacts_read.arn
}
