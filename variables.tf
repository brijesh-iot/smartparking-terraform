variable "core_name" {
  type        = string
  description = "Name of Project/Core"
}

variable "cf_templates_dir" {
  type        = string
  description = "Directory path of CloudFormation templates"
}

variable "env" {
  type        = string
  description = "Environment Type"
}

variable "app_version" {
  type        = string
  description = "Version Number"
}

variable "github_username" {
  type        = string
  description = "GitHub Account User Name"
}

variable "repo_type" {
  type        = string
  description = "Type of Repositiory - AWS CodeCommit or GitHub"
}

variable "event_type" {
  type        = string
  description = "Type of Environment test or prod"
}