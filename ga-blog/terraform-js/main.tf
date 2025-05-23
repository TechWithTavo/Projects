provider "aws"{
    region ="us-east-1"
}

#S3 Bucket
resource "aws_s3_bucket" "nextjs_bucket"{
    bucket = "nextjs-portfolio-bucket-ga"
}

#Ownership Control
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls"{
    bucket = aws_s3_bucket.nextjs_bucket.id
    rule {
        object_ownership = "BucketOwnerPrefered"
    }
}
#Block Public Access
resource"aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
    bucket =aws_s3_bucket.nextjs_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

#Bucket ACL 

resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
    depends_on = [
        aws_s3_bucket_ownership_controls.nextjs,
        aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
     ]
    bucket = aws_s3_bucket.nextjs_bucket.id
    acl = "public-read"
}

#Bucket Policy 
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
    bucket = aws_s3_bucket.nextjs_bucket.id
    policy = jsondecode(({
      version = "2012-10-17"
      Statement = [
        {
          Sid = "PublicReadGetObject"
          Effect = "Allow"
          Principal = "*"
          Action = "s3:GetObject"
          Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*"
        }
        ]
    }))
}
  enabled             = true
  is_ipv6_enabled = true
  comment = "Next.js portfolio site"
  default_root_object = "index.html"
}
  
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]   
    target_origin_id = "S3-nextjs-portfolio-bucket-ga" 

    forwarded_values {
      query_string = false
    }
      cookies {
        forward = "none"
      }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    }
    viewer_certificate {
      
    }
    restrictions {
    
    }