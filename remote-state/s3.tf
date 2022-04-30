resource "aws_s3_bucket" "s3-bucket" {
  bucket = "pa-devops-terraform-state"

  object_lock_enabled = true

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_versioning" "ad" {
  bucket = aws_s3_bucket.s3-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ad" {
  bucket = aws_s3_bucket.s3-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "ad" {
  bucket = aws_s3_bucket.s3-bucket.bucket

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}
