#VPC
variable "aws_region" {
  description = "AWS region to deploy in"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for all VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the bastion instance"
  type        = string
}

#BASTION
variable "instance_type" {
  description = "Instance type for bastion"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into bastion"
  type        = string
}

variable "key_pair_name" {
  description = "SSH key pair name"
  type        = string
}


#EKS
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.33"
}

variable "map_user_userarn" {
  description = "IAM user ARN for aws-auth configmap"
  type        = string
}

variable "map_user_username" {
  description = "Username mapped in aws-auth"
  type        = string
}

variable "map_user_groups" {
  description = "Groups assigned in aws-auth"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired node group size"
  type        = number
}

variable "max_size" {
  description = "Max node group size"
  type        = number
}

variable "min_size" {
  description = "Min node group size"
  type        = number
}

variable "eks_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_name" {
  description = "Name tag for node group"
  type        = string
}

variable "bastion_sg_eks_rule_port" {
  description = "Port for bastion access to EKS API"
  type        = number
  default     = 443
}