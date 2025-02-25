output "function_arn" {
  value = aws_lambda_function.lambda_function.arn
}

output "qualified_arn" {
  value = aws_lambda_function.lambda_function.qualified_arn
}
