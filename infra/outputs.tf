output "bucket_name" {
  description = "Nom du bucket S3 créé"
  value       = aws_s3_bucket.website_bucket.bucket
}

output "bucket_domain_name" {
  description = "Nom de domaine du bucket S3"
  value       = aws_s3_bucket.website_bucket.bucket_domain_name
}

output "website_endpoint" {
  description = "Endpoint du site web S3"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "website_url" {
  description = "URL du site web S3"
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}

output "cloudfront_distribution_id" {
  description = "ID de la distribution CloudFront"
  value       = aws_cloudfront_distribution.website_distribution.id
}

output "cloudfront_domain_name" {
  description = "Nom de domaine CloudFront"
  value       = aws_cloudfront_distribution.website_distribution.domain_name
}

output "cloudfront_url" {
  description = "URL CloudFront (recommandée pour la production)"
  value       = "https://${aws_cloudfront_distribution.website_distribution.domain_name}"
}
