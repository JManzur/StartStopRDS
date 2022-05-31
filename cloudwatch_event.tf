# IMPORTANT: All schedule CloudWatch events use UTC time (GMT +0)
#   23:00 UTC = 19:00 EST
#   12:50 UTC = 08:50 EST

# Event Rule to STOP EC2
resource "aws_cloudwatch_event_rule" "auto-stop-ec2-mon-fri" {
  name                = "auto-stop-rds-mon-fri"
  description         = "Auto Stop RDS at 19:00 EST Monday to Friday"
  schedule_expression = "cron(0 23 ? * MON-FRI *)"
  is_enabled          = false
}

resource "aws_cloudwatch_event_target" "lambda_stop_target" {
  rule      = aws_cloudwatch_event_rule.auto-stop-ec2-mon-fri.name
  target_id = "lambda"
  arn       = aws_lambda_function.StartStopRDS.arn
  input     = "{\"action\":\"stop\"}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_stop_ec2_function" {
  statement_id  = "AllowStopExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.StartStopRDS.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.auto-stop-ec2-mon-fri.arn
}

# Event Rule to START EC2
resource "aws_cloudwatch_event_rule" "auto-start-ec2-mon-fri" {
  name                = "auto-start-rds-mon-fri"
  description         = "Auto start RDS at 08:50 EST Monday to Friday"
  schedule_expression = "cron(50 12 ? * MON-FRI *)"
  is_enabled          = false
}

resource "aws_cloudwatch_event_target" "lambda_start_target" {
  rule      = aws_cloudwatch_event_rule.auto-start-ec2-mon-fri.name
  target_id = "lambda"
  arn       = aws_lambda_function.StartStopRDS.arn
  input     = "{\"action\":\"start\"}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_star_ec2_function" {
  statement_id  = "AllowStartExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.StartStopRDS.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.auto-start-ec2-mon-fri.arn
}