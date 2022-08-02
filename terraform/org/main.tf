locals {
  bucket_name = "ans-demo-cloudtrail"
  log_streams = [
    "${module.log_group.cloudwatch_log_group_arn}:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_${data.aws_region.current.name}*",
    "${module.log_group.cloudwatch_log_group_arn}:log-stream:${data.aws_organizations_organization.current.id}_*"
  ]
  trail_name = "ans-demo-cloudtrail"
  trail_arn = (
    "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${local.trail_name}"
  )
}

module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.3.0"

  name              = local.trail_name
  retention_in_days = 7
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> v5.2.0"

  name        = "ans-demo-cloudtrail"
  description = "Policy to permit cloudtrail to write to cloudwatch logs"
  policy      = data.aws_iam_policy_document.cloudwatch.json
}

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> v5.2.0"

  create_role       = true
  role_requires_mfa = false
  role_name         = "ans-demo-cloudtrail-cloudwatchlogs"
  trusted_role_services = [
    "cloudtrail.amazonaws.com"
  ]

  custom_role_policy_arns = [
    module.iam_policy.arn
  ]
}

#! tfsec:ignore:aws-cloudtrail-enable-at-rest-encryption
resource "aws_cloudtrail" "this" {
  depends_on = [
    module.s3_bucket
  ]
  name           = "ans-demo-cloudtrail"
  enable_logging = true

  s3_bucket_name             = local.bucket_name
  is_multi_region_trail      = true
  is_organization_trail      = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "${module.log_group.cloudwatch_log_group_arn}:*"
  cloud_watch_logs_role_arn  = module.iam_assumable_role.iam_role_arn
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.3.0"

  bucket                  = local.bucket_name
  force_destroy           = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.bucket_policy.json
}
