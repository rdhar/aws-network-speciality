variable "enable_cloudfront" {
  description = "Feature toggle for the cloudfront distribution"
  type        = bool
  default     = false
}

variable "demo_domain_name" {
  description = "Route53 domain name registered for the demo"
  type        = string
  default     = null
}

variable "secure_s3_bucket" {
  description = "Set to true to restrict access to the S3 bucket to the CloudFront OAI"
  type        = bool
  default     = false
}
