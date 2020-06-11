#create s3 bucket 
resource "aws_s3_bucket" "Prince" {
  bucket = "pps-prince"
  acl    = "private"

  tags = {
    Name        = "PPS"
    Environment = "Dev"
  }
}
#create cloud front
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "pps-prince.s3.amazonaws.com"
    origin_id   = "S3-pps-prince"

    s3_origin_config {
      origin_access_identity = "access-identity-pps-prince.s3.amazonaws.com"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "https://pps-prince.s3.ap-south-1.amazonaws.com/PicsArt_05-14-05.38.24.jpg"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "https://pps-prince.s3.ap-south-1.amazonaws.com/PicsArt_05-14-05.38.24.jpg"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }


  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
