variable "env" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "id of vpc"
  type        = string
  default      = "vpc-0a09686505f2c4051"
}

variable "enable_cluster_autoscaler" {
  description = "Determines whether to deploy cluster autoscaler"
  type        = bool
  default     = false
}

variable "cluster_autoscaler_helm_verion" {
  description = "Cluster Autoscaler Helm verion"
  type        = string
}

# variable "openid_provider_arn" {
#   description = "IAM Openid Connect Provider ARN"
#   type        = string
# }