locals {
  acm_arn    = "arn:aws:acm:us-east-1:943714519719:certificate/da78f723-87bf-4b45-b064-91c66a194da9"
  alias_main = "hoge.sandbox.rizap.jp"
  alias_sub  = "fuga.sandbox.rizap.jp"
}


resource "aws_s3_bucket" "default" {
  bucket = "arimura-test-cf-switch"
}

#######################
# Cloudfront Distribution
#######################
resource "aws_cloudfront_distribution" "default" {
  aliases         = [local.alias_sub]
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"

  viewer_certificate {
    acm_certificate_arn      = local.acm_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.default.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  origin {
    domain_name = aws_s3_bucket.default.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.default.id
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}


resource "aws_cloudfront_distribution" "sub" {
  aliases         = [local.alias_main]
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"

  viewer_certificate {
    acm_certificate_arn      = local.acm_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.default.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  origin {
    domain_name = aws_s3_bucket.default.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.default.id
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
