terraform{
    backend "s3" {
      bucket         = "ga-my-terraform-state"
      key            = "global/s3/terraform.tfstate"
      region         = "us-east-1"
      dynamodb_table = "terraform-lock-file"
        
}

#Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin Access Identity for Next.js S3 Bucket"
}

#CloudFront Distribution
resource "aws_cloudfront_distribution" "nextjs_distribution" {
  origin {
    domain_name = aws_s3_bucket.nextjs_bucket.bucket_regional_domain_name
    origin_id   = "S3-nextjs-portfolio-bucket-ga"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
