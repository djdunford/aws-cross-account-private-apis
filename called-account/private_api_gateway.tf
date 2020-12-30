resource "aws_api_gateway_rest_api" "private_mocks" {
  name = "private_mocks"
//  body = data.template_file.private_mocks_swagger.rendered
  body = <<EOF
openapi: "3.0.1"
info:
  title: "Private Mocks"
  version: "2017-04-20T04:08:08Z"
servers:
  - url: http://example.com/
    variables:
      basePath:
        default: /v1
paths:
  /get:
    get:
      operationId: mockGetGet
      description: Simulated GET API, returns a fixed response
      x-amazon-apigateway-integration:
        statuscode: "200"
        requestTemplates:
          application/json: "{\"statusCode\": 200}"
        passthroughBehavior: "when_no_match"
        type: "mock"
        responses:
          default:
            statusCode: "200"
            responseTemplates:
              application/json: "{\"statusCode\": 200,\"message\": \"OK\"}"
      responses:
        200:
          description: "OK"
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/Empty"
components:
  schemas:
    Empty:
      title: "Empty Schema"
      type: "object"
  securitySchemes:
    sigv4:
      type: "apiKey"
      name: "Authorization"
      in: "header"
      x-amazon-apigateway-authtype: "awsSigv4"
x-amazon-apigateway-policy:
  Version: '2012-10-17'
  Statement:
  - Effect: Allow
    Principal: "*"
    Action: execute-api:Invoke
    Resource:
    - execute-api:/*
  - Effect: Deny
    Principal: "*"
    Action: execute-api:Invoke
    Resource:
    - execute-api:/*
    Condition:
      IpAddress:
        aws:SourceIp: 192.0.2.0/24
EOF

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

data "template_file" "private_mocks_swagger" {
  template = "./services/api/private-mocks.yml"
}

resource "aws_api_gateway_deployment" "private_mocks_deployment" {
  rest_api_id = aws_api_gateway_rest_api.private_mocks.id
  stage_name  = "mocks"
}