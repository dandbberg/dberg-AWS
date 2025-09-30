output "vpc_id" {
  value = var.vpc_id
}

output "private_subnet_ids" {
  value = var.subnet_ids
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  value = var.full_cluster_name  # or however you call your cluster name internally
}

output "cluster_name" {
  value = var.full_cluster_name
}