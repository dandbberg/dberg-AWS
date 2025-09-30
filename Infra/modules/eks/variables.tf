variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "full_cluster_name" {
  description = "Full EKS cluster name including prefix"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.23" # or whatever you want
}

variable "vpc_id" {
  description = "VPC ID to deploy EKS in"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for worker nodes"
  type        = list(string)
}

variable "map_user_userarn" {
  description = "IAM user ARN for aws-auth configmap"
  type        = string
}

variable "map_user_username" {
  description = "User name for aws-auth configmap"
  type        = string
}

variable "map_user_groups" {
  description = "Groups for aws-auth configmap"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired size of node group"
  type        = number
}

variable "max_size" {
  description = "Max size of node group"
  type        = number
}

variable "min_size" {
  description = "Min size of node group"
  type        = number
}

variable "eks_instance_type" {
  description = "EKS worker node instance type"
  type        = string
  default     = "t3.medium"
}

variable "node_name" {
  description = "Name tag for nodes"
  type        = string
}

variable "bastion_sg_eks_rule_port" {
  description = "Port for bastion security group to access EKS API"
  type        = number
  default     = 443
}

variable "bastion_sg_id" {
  description = "Security group ID of the bastion host"
  type        = string
}