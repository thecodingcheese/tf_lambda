resource "aws_lambda_function" "lambda" {
  count = "${! var.attach_vpc_config ? 1 : 0}"

  # ----------------------------------------------------------------------------
  # IMPORTANT:
  # Changes made to this resource should also be made to "lambda_with_*" below.
  # ----------------------------------------------------------------------------

  function_name                  = "${var.function_name}"
  description                    = "${var.description}"
  role                           = "${aws_iam_role.lambda.arn}"
  handler                        = "${var.handler}"
  memory_size                    = "${var.memory_size}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  runtime                        = "${var.runtime}"
  timeout                        = "${var.timeout}"
  tags                           = "${var.tags}"

  # Use a generated filename to determine when the source code has changed.

  filename   = "${var.function_name}.zip"
  depends_on = ["data.archive_file.lambda_zip"]

  environment = ["${slice( list(var.environment), 0, length(var.environment) == 0 ? 0 : 1 )}"]
}

# The vpc_config is a lists of maps which,
# due to a bug or missing feature of Terraform, do not work with computed
# values. So here is a copy and paste of of the above resource for every
# combination of these variables.

resource "aws_lambda_function" "lambda_with_vpc" {
  count = "${var.attach_vpc_config ? 1 : 0}"

  vpc_config {
    security_group_ids = ["${var.vpc_config["security_group_ids"]}"]
    subnet_ids         = ["${var.vpc_config["subnet_ids"]}"]
  }

  # ----------------------------------------------------------------------------
  # IMPORTANT:
  # Everything below here should match the "lambda" resource.
  # ----------------------------------------------------------------------------

  function_name                  = "${var.function_name}"
  description                    = "${var.description}"
  role                           = "${aws_iam_role.lambda.arn}"
  handler                        = "${var.handler}"
  memory_size                    = "${var.memory_size}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  runtime                        = "${var.runtime}"
  timeout                        = "${var.timeout}"
  tags                           = "${var.tags}"
  filename                       = "${var.function_name}.zip"
  depends_on                     = ["data.archive_file.lambda_zip"]
  environment                    = ["${slice( list(var.environment), 0, length(var.environment) == 0 ? 0 : 1 )}"]
}
