locals {
  prefix = "${var.core_name}-${var.app_version}-${var.env}"
}

resource "aws_s3_bucket" "cf_templates" {

  bucket = "${local.prefix}-cf-templates"
  acl    = "private"

  tags = {
    Name        = "${local.prefix}-cf-templates"
    Environment = "${var.env}"
  }

}

resource "aws_s3_bucket_object" "cf_template_files" {

  for_each = fileset("${path.cwd}/cftemplates/", "*.*")
  bucket   = aws_s3_bucket.cf_templates.bucket
  key      = replace(each.value, var.cf_templates_dir, "")
  source   = "${path.cwd}/cftemplates/${each.value}"
  acl      = "private"
  etag     = filemd5("${path.cwd}/cftemplates/${each.value}")
  #content_type  = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])

}

resource "aws_cloudformation_stack" "main_template" {
  name         = "${local.prefix}-Main"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  on_failure   = "ROLLBACK"

  parameters = {
    MyKeyPair                     = "smartparking"
    GGInstanceType                = "t3.small"
    KepwareInstanceType           = "t2.xlarge"
    IgnitionInstanceType          = "t2.large"
    CloudFormationTemplatesBucket = aws_s3_bucket.cf_templates.bucket
    CoreName                      = "${var.core_name}"
    EdgeCodeRepoName              = "smartparking-edge-repo"
    BuildComputeType              = "BUILD_GENERAL1_SMALL"
    BuildImagePython              = "aws/codebuild/python:3.7.1"
    IoTCoreCodeRepoName           = "smartparking-iot-core-repo"
    IoTApiCodeRepoName            = "smartparking-api-repo"
    SimulationRepoName            = "smartparking-simulators"
    DocumentationRepoName         = "smartparking-docs"
    EnvType                       = "${var.event_type}"
    GitHubOwner                   = "${var.github_username}"
    RepoType                      = "${var.repo_type}"
  }

  template_body = "${file("${path.cwd}/cftemplates/main.yaml")}"

}


/*



data "aws_iam_policy_document" "CF_Service_Role_Policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["cloudformation.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "CF_Service_Role" {
  assume_role_policy = "${data.aws_iam_policy_document.CF_Service_Role_Policy.json}"
  name               = "CF_Service_Role"
}

data "aws_iam_policy_document" "CF_Service_Role_ExecutionPolicy" {
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/${aws_cloudformation_stack.main_template.execution_role_name}"]
  }
}

resource "aws_iam_role_policy" "CF_Service_Role_ExecutionPolicy" {
  name   = "ExecutionPolicy"
  policy = "${data.aws_iam_policy_document.CF_Service_Role_ExecutionPolicy.json}"
  role   = "${aws_iam_role.CF_Service_Role.name}"
}
*/




/*resource "null_resource" "upload_to_s3" {
  provisioner "local-exec" {
    command = <<EOF
    echo ------Start----------------------------------
    pwd
    ls
    echo "${path.cwd}/cftemplates/"
    aws s3 sync "/var/jenkins_home/workspace/SmartParking-Infra-Setup-v1/cftemplates" "s3://smartparking-v1-test-cf-templates/"
    echo ------End------------------------------------
    EOF
  }
}*/

#resource "aws_kms_key" "mykey" {
#  description             = "This key is used to encrypt bucket objects"
#  deletion_window_in_days = 30
#}


/* Put insise S3 bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.mykey.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }*/