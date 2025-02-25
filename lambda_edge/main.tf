locals {
  source_file_name = "${path.module}/resources/function_sample"
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_file = local.source_file_name
  output_path = "${local.source_file_name}.zip"
}

resource "aws_lambda_function" "lambda_function" {
  filename         = "${local.source_file_name}.zip"
  function_name    = "${var.service_name}-${var.resource_name}-function"
  role             = var.iam_role_arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = data.archive_file.function_zip.output_base64sha256
  publish          = true

  lifecycle {
    ignore_changes = [
      source_code_hash,
      publish,
      filename
    ]
  }

  tags = {
    Name = var.service_name
  }
}
