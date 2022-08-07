output "s3_website_url" {
  description = "The S3 Bucket website endpoint"
  value       = "http://${module.s3_bucket.s3_bucket_website_endpoint}"
}

output "cloudfront_url" {
  description = "The CloudFront distribution domain name"
  value       = module.cdn[*].cloudfront_distribution_domain_name
}

output "certificat_arn" {
  description = "The arn of the ACM certificate"
  value       = module.acm[*].acm_certificate_arn
}

output "alternate_cname" {
  description = "The CNAME records associated with CloudFront"
  value       = var.demo_domain_name != null ? "https://${local.alternate_cname}" : null
}
