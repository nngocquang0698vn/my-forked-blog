---
title: "Triggering an AWS Lambda from the Command-Line"
description: "How to invoke an AWS Lambda function from the Command-Line."
tags:
- blogumentation
- aws
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-23T13:16:57+0000
slug: "trigger-lambda-cli"
image: https://media.jvt.me/770ef46545.png
---
As I'm starting to get more involved with playing with AWS Lambdas, I wondered if there was a better way to test the deployed Lambda without using the AWS UI.

It turns out [this is well documented by AWS](https://docs.aws.amazon.com/lambda/latest/dg/invocation-sync.html), and we can use the AWS CLI, but it depends on which AWS CLI version you're using:

```sh
$ aws --version
# if version 1
$ aws lambda invoke --function-name my-function --payload '{ "key": "value" }' response.json
# if version 2
$ aws lambda invoke --function-name my-function --invocation-type RequestResponse --payload '{ "key": "value" }' --cli-binary-format raw-in-base64-out response.json
```

This outputs information about whether the operation was a success to `stdout`, and the Lambda's response to `response.json`.

Remember that if you're using different AWS accounts/profiles, you'll need to [specify the AWS profile](/posts/2018/11/15/aws-profile-cli-sdk/) before you run the above command.
