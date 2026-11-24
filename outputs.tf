output "cluster_name" {
  description = "The Name of the GKE Enterprise cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The IP address of the GKE cluster control plane"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  description = "Public CA certificate used by clients to authenticate to the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "workload_identity_pool" {
  description = "The Workload Identity Pool configured for this cluster"
  value       = "${var.project_id}.svc.id.goog"
}

output "node_service_account_email" {
  description = "The service account email attached to GKE worker nodes"
  value       = google_service_account.gke_nodes.email
}

output "vpc_network_id" {
  description = "The ID of the custom VPC network"
  value       = google_compute_network.vpc.id
}
