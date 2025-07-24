provider "aws" {
  region = "us-east-1" # or your desired region
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-demo-bucket-12345" # <-- change this to a globally unique name

  force_destroy = true

  tags = {
    Name        = "Public S3 Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "public_bucket_controls" {
  bucket = aws_s3_bucket.public_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.public_bucket.arn}/*"
      }
    ]
  })
}
