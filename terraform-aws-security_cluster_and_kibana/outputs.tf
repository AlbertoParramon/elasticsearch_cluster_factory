# Outputs for Elasticsearch Cluster on AWS EKS

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.elasticsearch.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.elasticsearch.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = aws_eks_cluster.elasticsearch.vpc_config[0].cluster_security_group_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.elasticsearch.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.elasticsearch.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.elasticsearch.identity[0].oidc[0].issuer
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.elasticsearch.arn
}

output "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  value       = aws_vpc.elasticsearch.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "kubectl_config_command" {
  description = "Command to configure kubectl for the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.elasticsearch.name}"
}

output "cluster_info" {
  description = "Information about the EKS cluster"
  value = {
    name    = aws_eks_cluster.elasticsearch.name
    region  = var.aws_region
    version = aws_eks_cluster.elasticsearch.version
    endpoint = aws_eks_cluster.elasticsearch.endpoint
  }
}

# EFS File System ID
output "efs_file_system_id" {
  description = "EFS File System ID for shared certificates"
  value       = aws_efs_file_system.elasticsearch_certs.id
}

# EFS CSI Driver Role ARN
output "efs_csi_driver_role_arn" {
  description = "ARN of the EFS CSI Driver IAM Role"
  value       = aws_iam_role.efs_csi_driver.arn
}
