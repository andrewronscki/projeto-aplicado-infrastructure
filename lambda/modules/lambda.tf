data "archive_file" "test_lambda" {
  type        = "zip"
  source_file = "${local.nodejs_template_path}/index.js"
  output_path = "${local.output_path}/test_lambda.zip"
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "test-lambda"
  handler       = "index.handler"
  role          = aws_iam_role.test_lambda.arn
  runtime       = "nodejs14.x"

  filename = data.archive_file.test_lambda.output_path

  tags = local.common_tags

  environment {
    variables = {
      TESTE = "TESTE DO ANDRÉ"
    }
  }
}

resource "aws_lambda_permission" "test_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this.arn
}
