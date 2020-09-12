/*
output "CloudFormationDirectory" {
  value = template_dir.config.destination_dir
}
*/

output "CloudFormation_bucket" {
  value = aws_s3_bucket.cf_templates.bucket
}