# Variables for Elasticsearch Cluster on AWS EKS

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "elasticsearch-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_instance_type" {
  description = "Instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "elasticsearch_version" {
  description = "Elasticsearch version"
  type        = string
  default     = "9.1.3"
}

variable "kibana_version" {
  description = "Kibana version"
  type        = string
  default     = "9.1.3"
}

variable "elastic_password" {
  description = "Password for elastic user"
  type        = string
  default     = "example1234"
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Elasticsearch-Cluster"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
