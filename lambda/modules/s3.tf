resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}-${var.env}"
}

resource "aws_s3_bucket_notification" "lambda" {
  bucket = aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "teste/"
  }
}
