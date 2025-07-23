# Génération d'un suffixe aléatoire pour le nom du bucket
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Bucket S3 pour l'hébergement du site web statique
resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.bucket_name}-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "React App Website Bucket"
    Environment = var.environment
  }
}

# Configuration de l'hébergement web statique
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Configuration de l'accès public au bucket
resource "aws_s3_bucket_public_access_block" "website_bucket_pab" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Politique du bucket pour permettre l'accès public en lecture
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website_bucket_pab]
}

# Origin Access Control pour CloudFront
resource "aws_cloudfront_origin_access_control" "website_oac" {
  name                              = "website-oac"
  description                       = "OAC for React website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Distribution CloudFront pour la CDN
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.website_oac.id
    origin_id                = "S3-${aws_s3_bucket.website_bucket.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Configuration du cache par défaut
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.website_bucket.bucket}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Gestion des erreurs 404 pour les SPA React
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  # Restrictions géographiques
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Certificat SSL/TLS
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "React App CloudFront Distribution"
    Environment = var.environment
  }
}
