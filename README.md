# IIP - Lambda Terraform Module

<b>This Terraform module creates and uploads an AWS Lambda function 
</b>
* Creates a standard IAM role and policy for CloudWatch Logs.
  * Additional policies can be added if required.
* Zips up a source file or directory.

## Usage

```js
module "lambda" {
  
  source        = "../../modules/lambda"
  
  function_name = "iip-deploy-status"
  description   = "IIP deploy status task"
  handler       = "main.lambda_handler"
  runtime       = "python3.6"
  timeout       = 300

  // Specify a file or directory for the source code.
  source_path = "${path.module}/lambda.py"

  // Attach a policy.
  attach_policy = true
  policy        = "${data.aws_iam_policy_document.lambda.json}"

  // Deploy into a VPC.
  attach_vpc_config = true
  vpc_config {
    subnet_ids         = ["${aws_subnet.test.id}"]
    security_group_ids = ["${aws_security_group.test.id}"]
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attach_policy | Set this to true if using the policy variable | string | `false` | no |
| attach_vpc_config | Set this to true if using the vpc_config variable | string | `false` | no |
| description | Description of what your Lambda function does | string | `Managed by Terraform` | no |
| environment | Environment configuration for the Lambda function | map | `<map>` | no |
| function_name | A unique name for your Lambda function (and related IAM resources) | string | - | yes |
| handler | The function entrypoint in your code | string | - | yes |
| memory_size | Amount of memory in MB your Lambda function can use at runtime | string | `128` | no |
| policy | An addional policy to attach to the Lambda function | string | `` | no |
| reserved_concurrent_executions | The amount of reserved concurrent executions for this Lambda function | string | `0` | no |
| runtime | The runtime environment for the Lambda function | string | - | yes |
| source_path | The source file or directory containing your Lambda source code | string | - | yes |
| tags | A mapping of tags | map | `<map>` | no |
| timeout | The amount of time your Lambda function had to run in seconds | string | `10` | no |
| vpc_config | VPC configuration for the Lambda function | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_arn | The ARN of the Lambda function |
| function_name | The name of the Lambda function |
| role_arn | The ARN of the IAM role created for the Lambda function |
| role_name | The name of the IAM role created for the Lambda function |
