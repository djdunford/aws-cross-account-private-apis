resource "aws_api_gateway_rest_api" "private_mocks" {
  name = "private_mocks"
  body = "data.template_file.private_mocks_swagger"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_rest_api_policy" "private_mocks" {
  rest_api_id = aws_api_gateway_rest_api.private_mocks.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "execute-api:Invoke",
      "Resource": "${aws_api_gateway_rest_api.private_mocks.arn}",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "123.123.123.123/32"
        }
      }
    }
  ]
}
EOF
}

data "local_file" private_mocks_swagger{
  filename = "./services/api/example.1.yml"
}

resource "aws_api_gateway_deployment" "private_mocks_deployment" {
  rest_api_id = "aws_api_gateway_rest_api.private_mocks.id"
  stage_name  = "mocks"
}