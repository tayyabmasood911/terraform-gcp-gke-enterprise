variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = "enterprise-cloud-platform-prod"
}

variable "region" {
  description = "Google Cloud primary region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "GKE Enterprise cluster name"
  type        = string
  default     = "gke-enterprise-production"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "vpc-gke-enterprise"
}

variable "subnet_name" {
  description = "Name of the primary subnet"
  type        = string
  default     = "snet-gke-nodes"
}

variable "subnet_cidr" {
  description = "CIDR range for primary nodes"
  type        = string
  default     = "10.0.0.0/20"
}

variable "pods_cidr_name" {
  description = "Name of the secondary IP range for Pods"
  type        = string
  default     = "gke-pods-range"
}

variable "pods_cidr" {
  description = "CIDR range for Pods"
  type        = string
  default     = "10.4.0.0/14"
}

variable "services_cidr_name" {
  description = "Name of the secondary IP range for Services"
  type        = string
  default     = "gke-services-range"
}

variable "services_cidr" {
  description = "CIDR range for Services"
  type        = string
  default     = "10.8.0.0/20"
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the private GKE control plane"
  type        = string
  default     = "172.16.0.0/28"
}

variable "release_channel" {
  description = "GKE auto-upgrade release channel (RAPID, REGULAR, STABLE)"
  type        = string
  default     = "REGULAR"
}

variable "system_node_count" {
  description = "Node count for system node pool"
  type        = number
  default     = 3
}

variable "workload_node_min_count" {
  description = "Minimum node count for autoscaling workload pool"
  type        = number
  default     = 3
}

variable "workload_node_max_count" {
  description = "Maximum node count for autoscaling workload pool"
  type        = number
  default     = 10
}
